HOST_PORT=8889
SLIDES_PORT=8000
BASENOTEBOOK=jupyter/scipy-notebook
NOTEBOOKS=`pwd`:/home/jovyan/work

IMAGE=crlane/python-trie-pres
PRESENTATION=Trie\ Time
.PHONY: pull image slides present run
.IGNORE: clean

clean:
	rm *.html

pull:
	docker pull ${BASENOTEBOOK}

image:
	docker build -t $(IMAGE) .

present: clean
	@docker run --rm -it -p $(SLIDES_PORT):$(SLIDES_PORT) -v $(NOTEBOOKS) $(IMAGE) jupyter nbconvert $(PRESENTATION).ipynb --to slides --post serve --log-level DEBUG --ServePostProcessor.ip='0.0.0.0'

run:
	docker run --rm -it -p $(HOST_PORT):$(HOST_PORT) -v $(NOTEBOOKS) $(IMAGE) jupyter notebook --port $(HOST_PORT)

demo-image:
	@docker build -t ${DEMO_IMAGE} -f Dockerfile-demo .

demo:
	@docker run --rm -it ${DEMO_IMAGE}
