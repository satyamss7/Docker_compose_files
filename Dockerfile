FROM ubuntu:22.04
LABEL Description="SDV someip SOA minimal"

ENV HOME /home/work

RUN apt-get update && apt-get -y --no-install-recommends install \
  	build-essential \
    	clang \
       	cmake \
	git \
	vim \
    	asciidoc \
	pkg-config \
	libboost-all-dev \
	net-tools \
	iputils-ping \
	ca-certificates \
	apt-utils

#RUN apt-get install -y minicom

RUN mkdir -p /home/work

WORKDIR ${HOME}

RUN git clone https://github.com/COVESA/vsomeip.git &&\
	cd vsomeip &&\
   	mkdir build && cd build &&\
        cmake .. ;\
        make ;\
        make install ;\
        cmake --build . --target examples ;\
        ldconfig  
#RUN pip install rpi.gpio 

RUN cd /home/work/vsomeip/examples
RUN git clone https://github.com/satyamss7/SOA_CODE_FOR_DOCKER.git
RUN cp -f /home/work/vsomeip/examples/SOA_CODE_FOR_DOCKER/CMakeLists.txt /home/work/vsomeip/examples/
RUN cp -f /home/work/vsomeip/examples/SOA_CODE_FOR_DOCKER/notify-sample.cpp /home/work/vsomeip/examples/
RUN cp -f /home/work/vsomeip/examples/SOA_CODE_FOR_DOCKER/subscribe-sample.cpp /home/work/vsomeip/examples/
RUN cp -f /home/work/vsomeip/examples/SOA_CODE_FOR_DOCKER/serialprt.hpp /home/work/vsomeip/examples/
RUN cp -f /home/work/vsomeip/examples/SOA_CODE_FOR_DOCKER/serial.cpp /home/work/vsomeip/examples/
RUN cp -f /home/work/vsomeip/examples/SOA_CODE_FOR_DOCKER/serialprt.hpp /home/work/vsomeip/examples/
RUN cd /home/work/vsomeip/build/
RUN cmake ..
RUN make
RUN make install
RUN cmake --build . --target examples
RUN ldconfig

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
        
       
        

