run:
	sudo docker container ls -a | grep lorawan-server-xenial || make install
	sudo docker run -d -p 1680:1680 -p 8080:8080 lorawan-server:xenial	

install:
	test -f lorawan-server_0.6.4_all.deb || make build
	test -f esl-erlang_21.1.3-2~ubuntu~xenial_amd64.deb || \
	wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_21.1.3-2~ubuntu~xenial_amd64.deb
	sha256sum esl-erlang_21.1.3-2~ubuntu~xenial_amd64.deb | \
	grep a7d93f6ead6f61fea3162e0f418848a1199dfa8d59aef3f06b0d45dfa5e8f2ab
	sudo docker build -t lorawan-server:xenial -f Dockerfile.install .

build:
	sudo docker pull ubuntu:xenial
	test -f esl-erlang_21.1.3-2~ubuntu~xenial_amd64.deb || \
	wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_21.1.3-2~ubuntu~xenial_amd64.deb
	sha256sum esl-erlang_21.1.3-2~ubuntu~xenial_amd64.deb | \
	grep a7d93f6ead6f61fea3162e0f418848a1199dfa8d59aef3f06b0d45dfa5e8f2ab
	sudo docker build -t lorawan-server-build:xenial -f Dockerfile.build .
	sudo docker rm lorawan-server-xenial-build || true
	sudo docker create --name lorawan-server-xenial-build lorawan-server-build:xenial
	sudo docker cp lorawan-server-xenial-build:/home/user/lorawan-server/_build/default/rel/lorawan-server/lorawan-server_0.6.4_all.deb .
	sudo docker rm lorawan-server-xenial-build
