FROM cirrusci/flutter

WORKDIR /mobile-app

COPY . .

WORKDIR /mobile-app/area

RUN flutter clean

RUN flutter pub upgrade

RUN flutter pub get

CMD  ["flutter", "build", "apk"]