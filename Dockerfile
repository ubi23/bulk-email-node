FROM node:14.5.5-alpine
# Expect build args
ARG NPM_TOKEN

# Use this to install private npm packages
WORKDIR /usr/src/app
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > ~/.npmrc

# Copy all the files over.
COPY . .

# Install app dependencies and prune
RUN npm install && rm -f ~/.npmrc
RUN npm prune --production

EXPOSE 3000
CMD [ "npm", "start" ]