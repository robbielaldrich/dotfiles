package main 

import (
	"fmt"
	"io/fs"
	"log"
	"os"
)

func main() {
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

	if err := apply(homeRoot, dotfilesRoot); err != nil {
		log.Fatalf("failed to apply: %s", err)
	}
}

func apply(homeDir, dotfilesDir *os.Root) error {
	zshrc, err := dotfilesDir.ReadFile(".zshrc")
	if err != nil {
		return fmt.Errorf("failed to read dotfiles zshrc: %w", err)
	}

	if err := homeDir.WriteFile(".zshrc", zshrc, fs.ModePerm); err != nil {
		return fmt.Errorf("failed to write zshrc: %w", err)
	}

	return nil
}


