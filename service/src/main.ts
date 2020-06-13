import { Application } from "https://deno.land/x/oak/mod.ts";
import router from "./router.ts";
import { PORT, HOST } from "./config/config.ts";
const app = new Application();

app.use(router.routes());
app.use(router.allowedMethods());

console.log(`Server Port ${PORT}`);
app.listen({ hostname: HOST, port: PORT });
