// https://doc.deno.land/https/deno.land/x/mysql/mod.ts
import { Client } from "https://deno.land/x/mysql/mod.ts";
import { config } from "../config/config.ts";

const client = await new Client().connect(config);

export default client;
