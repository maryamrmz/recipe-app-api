FROM python:3.9-alpine3.13
LABEL maintainer="test"

ENV PYTHONUNBUFFERED 1
ENV PATH="/py/bin:$PATH"

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN apk add --update --no-cache \
        postgresql-client \
        build-base \
        postgresql-dev \
        musl-dev \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip setuptools wheel && \
    /py/bin/pip install -r /tmp/requirements.txt --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt --trusted-host pypi.org --trusted-host pypi.pythonhosted.org --trusted-host files.pythonhosted.org; \
    fi && \
    apk del build-base postgresql-dev musl-dev && \
    rm -rf /root/.cache && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

USER django-user
