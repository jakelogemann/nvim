DATE := $(shell date +%Y-%m-%d)

.PHONY: readme README README.adoc
readme README README.adoc:
	sed -E "s/^\:revdate\: [:alpha:]+\$/:revdate: $(DATE)/" README.adoc
commit:
	git commit -am "$(date +%+)"
push:
	git push -u origin HEAD
pull:
	git pull --rebase

.PHONY: commit push pull
