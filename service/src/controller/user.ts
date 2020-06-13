import { Context } from "https://deno.land/x/oak/mod.ts";
import userService from "../services/user.ts";
import { User } from "../models/user.ts";
const { cwd } = Deno;

class UserController {
  static async findAll(ctx: Context) {
    const user = await userService.findAll();
    ctx.response.body = user;
  }
  static async save(ctx: Context) {
    const data = await ctx.request.body();
    let user: User = {
      id: 0,
      userName: data.value.userName,
      passWord: data.value.passWord,
      type: data.value.type,
      delFlag: data.value.delFlag || 0
    };
    const saveUser = await userService.save(user);
    ctx.response.body = saveUser;
  }
}

export default UserController;
