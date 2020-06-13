import { User } from "../models/user.ts";
import UserRepo from "../repositories/userRepo.ts";
class userService {
  static async findAll() {
    return UserRepo.findAll();
  }
  static async save(user: User) {
    return UserRepo.save(user);
  }
}
export default userService;
