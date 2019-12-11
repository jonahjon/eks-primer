.PHONY:

clean:
	docker build -t tft --no-cache . 

build:
	docker build -t tft .

run:
	docker run -p 3000:80 tft:latest
	
retry: build run