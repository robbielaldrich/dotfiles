package main 

import (
	"fmt"
	"io/fs"
	"log"
	"os"
)


func main() {
	var f func(homeRoot, dotfilesRoot *os.Root) error

	if len(os.Args) == 2 && os.Args[1] == "apply" {
		f = apply
	} else if len(os.Args) == 2 && os.Args[1] == "copy-local" {
		f = copyLocal
	} else {
		log.Fatalf("provide command and no additional arguments")
	} 

	homePath, err := os.UserHomeDir()
	if err != nil {
		log.Fatalf("failed to get user home dir: %s", err)
	}

	dotfilesPath, err := os.Getwd()
	if err != nil {
		log.Fatalf("failed to get current working directory: %s", err)
	}

	homeRoot, err := os.OpenRoot(homePath)
	if err != nil {
		log.Fatalf("failed to open home dir: %s", err)
	}

	dotfilesRoot, err := os.OpenRoot(dotfilesPath)
	if err != nil {
		log.Fatalf("failed to open dotfiles dir: %s", err)
	}

	if err := f(homeRoot, dotfilesRoot); err != nil {
		log.Fatal(err)
	}
}

func apply(home, dotfiles *os.Root) error {
	return exec(home, dotfiles)
}

func copyLocal(home, dotfiles *os.Root) error {
	return exec(dotfiles, home)
}

func exec(dst, src *os.Root) error {
	for _, f := range []string{".zshrc", ".zshenv"} {
		data, err := src.ReadFile(f)
		if err != nil {
			return fmt.Errorf("failed to read source file '%s': %w", f, err)
		}

		if err := dst.WriteFile(f, data, fs.ModePerm); err != nil {
			return fmt.Errorf("failed to write destination file '%s': %w", f, err)
		}
	}

	return nil
}


