FROM python:3.9-alpine3.13
LABEL maintainer="recipe-app-api.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

#   python -m venv /py && \ هذا يقوم بإنشاء البيئة إفتراضية جديدة لتثبيت الاعتمادات فيها
#    rm -rf /tmp && \ لحذف الملفات التي لا تحتاجها داخل الصورة الزائدة خلال عملية البناء يساعد في تقليل حجم الصورة
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
#  لإنشاء مستخدم جديد داخل الصورة الافتراضي هو رووت ولديه جميع الصلاحيات: adduser
# django-user اسم المستخدم 
ENV PATH="/py/bin:$PATH"
#يقوم بتحديث متغيرات البيئة داخل الصورة
#PATH هو الذي يخبر النظام اين يبحث عن الملفات القابلة للتشغيل 
USER django-user
#تغير المسؤل عن الحاوية ل django-user