/**
 * @typedef {Object} Options
 * @property {boolean} notify
 * @property {boolean} bell
 * @property {bool} sound
 */
const options = {
  notify: true, // send notification
  bell: false, // trigger bell
  sound: false, // play sound
};

/**
 * @typedef {Object} NotificationDefault
 * @property {boolean} enable
 * @property {string} title
 * @property {string} subtitle
 * @property {string[]} body - Array of lines (will be dynamically joined)
 * @property {string} sound
 */
const NotificationDefault = {
  enable: false,
  title: "Opencode",
  subtitle: " ",
  body: [" "],
  sound: "ping",
};

export const NotificationPlugin = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  return {
    event: async ({ event }) => {
      let notification = NotificationDefault;
      switch (event.type) {
        case "session.idle": // Session Completion
          const sessionResponse = await client.session.get({
            path: { id: event.properties.sessionID },
          });
          notification = {
            ...NotificationDefault,
            enable: true,
            subtitle: "Waiting for Input",
            body: [`Session: '${sessionResponse.data.title}'`],
          };
          break;
        case "permission.updated": // Permission Needed
          notification = {
            ...NotificationDefault,
            enable: true,
            subtitle: "Permission Needed",
            body: [`Operation: '${event.properties.type}'`],
          };
          break;
        case "session.error": // session error
          notification = {
            ...NotificationDefault,
            enable: true,
            subtitle: "Session Error",
            body: [
              `Error: '${event.properties.error.errorInfo?.data?.message || "Unkown"}'`,
            ],
          };
          break;
        case "message.updated": // error message
          if (event.properties.info.error) {
            notification = {
              ...NotificationDefault,
              enable: true,
              subtitle: "Error Message",
              body: [
                `Error: '${event.properties.info.error.name}'`,
                `Details: '${event.properties.info.error.data.message || "Unkown"}'`,
              ],
            };
          } else {
            break;
          }
        default: // Base case
          break;
      }
      if (notification.enable) {
        if (options.notify) {
          let command = `display notification`;
          command += ` "${notification.body.join("\n")}"`;
          command += ` with title "${notification.title}"`;
          command += ` subtitle "${notification.subtitle}"`;
          if (options.sound) {
            command += ` sound name "${notification.sound}"`;
          }
          await $`osascript -e "${command}"`;
        }
        if (options.bell) {
          console.log("\x07");
        }
      }
    },
  };
};
