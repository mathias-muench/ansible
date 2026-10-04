    grep ^test.*cachedir mmu.sh | cut -d\> -f2 | while read i; do rm -r $(eval dirname $i)/*; done
