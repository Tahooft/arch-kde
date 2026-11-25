#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
output_file="${1:-$script_dir/package-lists/package-list-$(date +%y%m%d).txt}"
output_dir="$(dirname -- "$output_file")"
mkdir -p -- "$output_dir"
temporary_dir="$(mktemp -d)"
temporary_output="$(mktemp "${output_file}.tmp.XXXXXX")"

cleanup() {
	rm -f -- "$temporary_dir/pacman" "$temporary_dir/yay" \
		"$temporary_dir/flatpak" "$temporary_output"
	rmdir -- "$temporary_dir"
}
trap cleanup EXIT

: > "$temporary_dir/pacman"
: > "$temporary_dir/yay"
: > "$temporary_dir/flatpak"

extract_array_packages() {
	awk '
		/^[[:space:]]*list[[:space:]]*=[[:space:]]*\(/ {
			in_list = 1
			next
		}
		in_list && /^[[:space:]]*\)/ {
			in_list = 0
			next
		}
		in_list {
			sub(/[[:space:]]*#.*/, "")
			n = split($0, packages, /[[:space:]]+/)
			for (i = 1; i <= n; i++) {
				if (packages[i] != "") {
					print packages[i]
				}
			}
		}
	' "$1"
}

extract_pacman_commands() {
	awk '
		{
			line = $0
			sub(/^[[:space:]]*#.*/, "", line)
			sub(/[[:space:]]+#.*/, "", line)
			n = split(line, fields, /[[:space:]]+/)
			for (i = 1; i < n; i++) {
				if (fields[i] == "pacman" && fields[i + 1] == "-S") {
					for (j = i + 2; j <= n; j++) {
						if (fields[j] !~ /^-/ && fields[j] !~ /[$"]/ &&
							fields[j] != "&&" && fields[j] != ";") {
							print fields[j]
						}
					}
					break
				}
			}
		}
	' "$1"
}

extract_flatpak_packages() {
	awk '
		{
			line = $0
			sub(/^[[:space:]]+/, "", line)
			if (line == "" || line ~ /^#/) {
				next
			}

			sub(/[[:space:]]+#.*/, "", line)
			if (line ~ /(^|[[:space:]])flatpak[[:space:]]+install([[:space:]]|$)/) {
				n = split(line, fields, /[[:space:]]+/)
				install_seen = 0
				for (i = 1; i <= n; i++) {
					if (fields[i] == "install") {
						install_seen = 1
						continue
					}
					if (install_seen && fields[i] !~ /^-/ && fields[i] != "flathub") {
						print fields[i]
					}
				}
				next
			}

			if (line ~ /^#!/ || line ~ /^[[:alnum:]_.+-]+[[:space:]]*$/) {
				sub(/[[:space:]]+$/, "", line)
				print line
			}
		}
	' "$1"
}

for source_file in "$script_dir"/[0-9]*; do
	[[ -f "$source_file" ]] || continue

	case "$(basename "$source_file")" in
		070-*)
			extract_array_packages "$source_file" >> "$temporary_dir/yay"
			;;
		200-*)
			extract_array_packages "$source_file" >> "$temporary_dir/flatpak"
			extract_flatpak_packages "$source_file" >> "$temporary_dir/flatpak"
			;;
		*)
			extract_array_packages "$source_file" >> "$temporary_dir/pacman"
			extract_pacman_commands "$source_file" >> "$temporary_dir/pacman"
			;;
	esac
done

{
	printf '# Generated from numbered project scripts by generate-package-list.sh\n'
	printf '# These are configured package selections, not a list of installed system packages.\n\n'

	for manager in pacman yay flatpak; do
		printf '%s packages:\n' "$manager"
		sort -u "$temporary_dir/$manager"
		printf '\n'
	done
} > "$temporary_output"

chmod 0644 "$temporary_output"
mv -- "$temporary_output" "$output_file"
printf 'Package list written to %s\n' "$output_file"
