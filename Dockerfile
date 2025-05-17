FROM alpine:3.21.3

RUN apk update \
    && apk add --no-cache \
    bash=5.2.37-r0 \
    openssh=9.9_p2-r0 \
    sshpass=1.10-r0 \
    python3=3.12.10-r0 \
    py3-pip=24.3.1-r0 \
    && python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --upgrade --no-cache-dir \
    pip==25.0.1 \
    ansible==11.0.0 \
    passlib==1.7.4

ENV PATH="/venv/bin:$PATH"

COPY ./ansible.cfg /etc/ansible/ansible.cfg
COPY ./requirements.yml /tmp/requirements.yml

RUN ansible-galaxy collection install -r /tmp/requirements.yml

SHELL ["/bin/bash", "-c"]

CMD ["bash"]