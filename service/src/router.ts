import { Router } from "https://deno.land/x/oak/mod.ts";
import UserController from "./controller/user.ts";
import Auth from "./middleware/auth.ts";
const router = new Router();

router.get("/", UserController.findAll);
router.post("/save", UserController.save);

export default router;
