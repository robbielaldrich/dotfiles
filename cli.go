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
	for _, f := range []struct {
		path  string
		isDir bool
	}{
		{path: ".zshrc"},
		{path: ".zshenv"},
		{path: ".config/nvim", isDir: true},
	} {
		if f.isDir {
			if err := copyDir(dst, src, f.path); err != nil {
				return fmt.Errorf("failed to copy source directory '%s': %w", f.path, err)
			}

			continue
		}

		data, err := src.ReadFile(f.path)
		if err != nil {
			return fmt.Errorf("failed to read source file '%s': %w", f.path, err)
		}

		if err := dst.WriteFile(f.path, data, fs.ModePerm); err != nil {
			return fmt.Errorf("failed to write destination file '%s': %w", f.path, err)
		}
	}

	return nil
}

func copyDir(dst, src *os.Root, dir string) error {
	return fs.WalkDir(src.FS(), dir, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		if d.IsDir() {
			if err := dst.MkdirAll(path, fs.ModePerm); err != nil {
				return fmt.Errorf("failed to create destination directory '%s': %w", path, err)
			}

			return nil
		}

		data, err := src.ReadFile(path)
		if err != nil {
			return fmt.Errorf("failed to read source file '%s': %w", path, err)
		}

		if err := dst.WriteFile(path, data, fs.ModePerm); err != nil {
			return fmt.Errorf("failed to write destination file '%s': %w", path, err)
		}

		return nil
	})
}


