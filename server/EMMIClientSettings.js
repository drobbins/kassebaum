export const EMMIClientSettings = {
    username: process.env.EMMI_USERNAME,
    password: process.env.EMMI_PASSWORD,
    endpoint: process.env.EMMI_ENDPOINT,
    externalSystem: process.env.EMMI_EXTERNALSYSTEM
};

if (process.env.NODE_ENV === 'development') {
    process.env.MOCK_EMMI = 'true';
}

export default EMMIClientSettings;
