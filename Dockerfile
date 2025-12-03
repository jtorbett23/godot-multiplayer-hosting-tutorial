ARG EXECUTABLE_NAME="multiplayer-hosting-tutorial-server"

FROM ubuntu:focal AS build

# Install dependenices to download Godot and templates
RUN apt-get update && apt-get install -y --no-install-recommends \
ca-certificates \
unzip \
wget 

ENV GODOT_VERSION="4.5.1"
# Download Godot and templates
RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip 
RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz 

# Place Godot files in required folders
RUN mkdir -p ~/.cache ~/.config/godot ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_linux*.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux*64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable \
    && rm Godot_v${GODOT_VERSION}-stable_export_templates.tpz Godot_v${GODOT_VERSION}-stable_linux*.zip

# Create a space to build the executable
RUN mkdir /godotbuildspace
WORKDIR /godotbuildspace

# Copy our Godot project into the container
COPY . . 
ARG EXECUTABLE_NAME
ENV EXPORT_NAME="LinuxServer"
ENV EXECUTABLE_NAME=$EXECUTABLE_NAME

# Export the project in debug or release mode
ENV EXPORT_MODE="debug" 
RUN godot --export-${EXPORT_MODE} ${EXPORT_NAME} ${EXECUTABLE_NAME} --headless ./

# Start a new stage to execute the exectuable as we do not need the Godot files anymore
FROM ubuntu:focal

ARG EXECUTABLE_NAME
ENV EXECUTABLE_NAME=$EXECUTABLE_NAME
COPY --from=build /godotbuildspace/ ./

EXPOSE 6069/tcp
EXPOSE 6069/udp
CMD ["sh", "-c", "./${EXECUTABLE_NAME} --headless -s"]