# allows us to automate the build process of projects
# make is a language itself - can google about it for further inquiries
# in makefiles it is important to use TABS and not 4 spaces

#by default make will run the first label it sees
all:
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot.bin

clean:
	rm -rf ./bin/boot.bin