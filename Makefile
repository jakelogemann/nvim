commit:
	git commit -am "$(date +%+)"
push:
	git push -u origin HEAD
pull:
	git pull --rebase

.PHONY: commit push pull
