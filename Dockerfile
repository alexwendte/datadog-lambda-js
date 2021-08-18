ARG image
FROM $image

# RUN apk add --no-cache bash

# Create the directory structure required for AWS Lambda Layer
RUN mkdir -p /nodejs/node_modules/

# Install dev dependencies
COPY . datadog-lambda-js
WORKDIR /datadog-lambda-js

# Install dependencies
RUN yarn install --production=true
# Copy the dependencies to the modules folder
RUN cp -rf node_modules/* /nodejs/node_modules

# Remove the AWS SDK, which is installed in the lambda by default
RUN rm -rf /nodejs/node_modules/aws-sdk
RUN rm -rf /nodejs/node_modules/aws-xray-sdk-core/node_modules/aws-sdk

# Remove heavy files from dd-trace which aren't used in a lambda environment
RUN rm -rf /nodejs/node_modules/dd-trace/prebuilds
RUN rm -rf /nodejs/node_modules/dd-trace/dist
RUN rm -rf /nodejs/node_modules/hdr-histogram-js/build
RUN rm -rf /nodejs/node_modules/protobufjs/dist
RUN rm -rf /nodejs/node_modules/@types
