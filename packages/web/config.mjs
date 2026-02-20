const stage = process.env.SST_STAGE || "dev"

export default {
  url: stage === "production" ? "https://nelliecode.vibecaas.com" : `https://${stage}.nelliecode.vibecaas.com`,
  console:
    stage === "production" ? "https://console.nelliecode.vibecaas.com/auth" : `https://${stage}.nelliecode.vibecaas.com/auth`,
  email: "support@vibecaas.com",
  socialCard: "https://social-cards.sst.dev",
  github: "https://github.com/vibecaas/nellie-code",
  discord: "https://vibecaas.com/discord",
  headerLinks: [
    { name: "app.header.home", url: "/" },
    { name: "app.header.docs", url: "/docs/" },
  ],
}
