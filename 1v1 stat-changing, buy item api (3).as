package
{
   import com.epic.databox.*;
   import com.epic.datarecord.*;
   import com.epic.npcoptions.*;
   import com.sfs.*;
   import com.sfs.data.*;
   import fl.containers.*;
   import fl.controls.*;
   import fl.data.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class AbuseModule extends Module implements IModule
   {
      
      private static var _instance:AbuseModule;
      
      public static const VERSION_REPORT:String = "report";
       
      
      private var _ui:AbuseModuleUI;
      
      private var _charId:int;
      
      private var _charName:String;
      
      private var _reportedCharList:Array;
      
      public function AbuseModule()
      {
         if(_instance == null)
         {
            this._ui = new AbuseModuleUI();
            super(this._ui);
            addChild(this._ui);
            visible = false;
            tabEnabled = false;
            tabChildren = false;
            this.ui.reason_combo.removeAll();
            this.ui.reason_combo.addItem({
               "label":"SELECT REASON...",
               "data":0
            });
            this.ui.reason_combo.addItem({
               "label":ReportTypes.INAPPROPRIATE_LANGUAGE_STR,
               "data":ReportTypes.INAPPROPRIATE_LANGUAGE
            });
            this.ui.reason_combo.addItem({
               "label":ReportTypes.HARASSING_STR,
               "data":ReportTypes.HARASSING
            });
            this.ui.reason_combo.addItem({
               "label":ReportTypes.SPAMMING_STR,
               "data":ReportTypes.SPAMMING
            });
            this.ui.reason_combo.addItem({
               "label":ReportTypes.CHEATING_STR,
               "data":ReportTypes.CHEATING
            });
            this.ui.reason_combo.addItem({
               "label":ReportTypes.INAPPROPRIATE_CHARACTER_NAME_STR,
               "data":ReportTypes.INAPPROPRIATE_CHARACTER_NAME
            });
            this.ui.reason_combo.addItem({
               "label":ReportTypes.INAPPROPRIATE_FACTION_NAME_STR,
               "data":ReportTypes.INAPPROPRIATE_FACTION_NAME
            });
            this.ui.reason_combo.selectedIndex = 0;
            this.ui.reason_combo.rowCount = this.ui.reason_combo.length;
            this.ui.comment_txt.maxChars = 200;
            this.ui.comment_txt.restrict = "^\\^";
            this.ui.done_btn.addEventListener(MouseEvent.CLICK,this.closeModule,false,0,true);
            this.ui.report_btn.addEventListener(MouseEvent.CLICK,this.reportPlayerHandler,false,0,true);
            this._reportedCharList = [];
            return;
         }
         throw new Error("Error: Singleton - Use AbuseModule.instance");
      }
      
      public static function get instance() : AbuseModule
      {
         if(_instance == null)
         {
            _instance = new AbuseModule();
         }
         return _instance;
      }
      
      public function get ui() : AbuseModuleUI
      {
         return this._ui;
      }
      
      public function addCharToReportedList(param1:int) : void
      {
         this._reportedCharList.push(param1);
      }
      
      override public function loadLangText() : void
      {
         this.ui.report_btn.label = GlobalLanguage.loadString("DYN_report_btn_submit");
      }
      
      public function closeModule(param1:MouseEvent = null) : void
      {
         this.visible = false;
      }
      
      public function show(param1:String, param2:ActorBase) : void
      {
         var _loc3_:NotificationParams = null;
         if(this._reportedCharList.indexOf(param2.charId) != -1)
         {
            EpicSound.playEffect(EpicSound._soundError);
            _loc3_ = new NotificationParams();
            _loc3_.graphic = new Window_304_97("You have already reported " + param2.charName);
            NotificationModule.instance.displayNotification(_loc3_);
            return;
         }
         this._charId = param2.charId;
         this._charName = param2.charName;
         this.ui.title_txt.text = GlobalLanguage.loadStringParams("DYN_report_txt_reportwho",[this._charName]);
         this.ui.reason_combo.selectedIndex = 0;
         this.ui.comment_txt.text = "";
         visible = true;
      }
      
      public function grabPlayerInfo() : void
      {
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charName: " + Character._selectedCharacter.charName);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charId: " + Character._selectedCharacter.charId);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"sfsUserId: " + Character._selectedCharacter.sfsUserId);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"dbUserId: " + Character._selectedCharacter.dbUserId);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charGender: " + Character._selectedCharacter.charGender);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"fctName: " + Character._selectedCharacter.fctName);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"fctId: " + Character._selectedCharacter.fctId);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charTitle: " + Character._selectedCharacter.charTitle);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iWpn: " + Character._selectedCharacter.iWpn);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iBot: " + Character._selectedCharacter.iBot);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iVeh: " + Character._selectedCharacter.iVeh);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iGun: " + Character._selectedCharacter.iGun);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iAux: " + Character._selectedCharacter.iAux);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charArm: " + Character._selectedCharacter.charArm);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"fctPerm: " + Character._selectedCharacter.fctPerm);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"rating: " + Character._selectedCharacter.rating);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"userChatBlock: " + Character._selectedCharacter.userChatBlock);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"targetId: " + Character._selectedCharacter._targetId);
      }
      
      public function getVars() : void
      {
         var charVars:Array = [];
         var _loc1_:Array = EpicDuel.getMyUser().getVariables();
         charVars = EpicUtils.duplicateArray(_loc1_);
         charVars["charHairS"] = 324;
         NotificationModule.instance.createNotification(new Window_304_97("Grabbed Player Variables"));
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charName: " + charVars["charName"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"userId: " + charVars["userId"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charId: " + charVars["charId"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charGender: " + charVars["charGender"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charClassId: " + charVars["charClassId"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charHairS: " + charVars["charHairS"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"mT: " + charVars["mT"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charScaleX: " + charVars["charScaleX"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charArm: " + charVars["charArm"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iWpn: " + charVars["iWpn"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iGun: " + charVars["iGun"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iAux: " + charVars["iAux"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iBot: " + charVars["iBot"]);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iVeh: " + charVars["iVeh"]);
      }
      
      public function getAllSkillNames() : void
      {
         var skill_1:SkillRecord = null;
         var skill_2:SkillRecord = null;
         var skill_3:SkillRecord = null;
         var skill_4:SkillRecord = null;
         var skill_5:SkillRecord = null;
         var skill_6:SkillRecord = null;
         var skill_7:SkillRecord = null;
         var skill_8:SkillRecord = null;
         var skill_9:SkillRecord = null;
         var skill_10:SkillRecord = null;
         var skill_11:SkillRecord = null;
         var skill_12:SkillRecord = null;
         var name:int = 0;
         var getSkillNameById:Array = SkillTreeBox.instance.getAllSkillIdsByClass(EpicDuel.getMyUser().charClassId);
         var skill:Array = [];
         for each(name in getSkillNameById)
         {
            skill.push(name);
            skill_1 = SkillsAllBox.instance.getSkillById(skill[0]);
            skill_2 = SkillsAllBox.instance.getSkillById(skill[1]);
            skill_3 = SkillsAllBox.instance.getSkillById(skill[2]);
            skill_4 = SkillsAllBox.instance.getSkillById(skill[3]);
            skill_5 = SkillsAllBox.instance.getSkillById(skill[4]);
            skill_6 = SkillsAllBox.instance.getSkillById(skill[5]);
            skill_7 = SkillsAllBox.instance.getSkillById(skill[6]);
            skill_8 = SkillsAllBox.instance.getSkillById(skill[7]);
            skill_9 = SkillsAllBox.instance.getSkillById(skill[8]);
            skill_10 = SkillsAllBox.instance.getSkillById(skill[9]);
            skill_11 = SkillsAllBox.instance.getSkillById(skill[10]);
            skill_12 = SkillsAllBox.instance.getSkillById(skill[11]);
         }
         return this.ui.comment_txt.text = "skillNames - \n" + "\nskillId: " + skill_1.skillId + "\nskillName: " + skill_1.skillName + "\nskillDesc: " + skill_1.skillDesc + "\nskillLink: " + skill_1.skillLink + "\nskillPassive: " + skill_1.skillPassive + "\nskillImproves: " + skill_1.skillImproves + "\n" + "\nskillId: " + skill_2.skillId + "\nskillName: " + skill_2.skillName + "\nskillDesc: " + skill_2.skillDesc + "\nskillLink: " + skill_2.skillLink + "\nskillPassive: " + skill_2.skillPassive + "\nskillImproves: " + skill_2.skillImproves + "\n" + "\nskillId: " + skill_3.skillId + "\nskillName: " + skill_3.skillName + "\nskillDesc: " + skill_3.skillDesc + "\nskillLink: " + skill_3.skillLink + "\nskillPassive: " + skill_3.skillPassive + "\nskillImproves: " + skill_3.skillImproves + "\n" + "\nskillId: " + skill_4.skillId + "\nskillName: " + skill_4.skillName + "\nskillDesc: " + skill_4.skillDesc + "\nskillLink: " + skill_4.skillLink + "\nskillPassive: " + skill_4.skillPassive + "\nskillImproves: " + skill_4.skillImproves + "\n" + "\nskillId: " + skill_5.skillId + "\nskillName: " + skill_5.skillName + "\nskillDesc: " + skill_5.skillDesc + "\nskillLink: " + skill_5.skillLink + "\n:skillPassive: " + skill_5.skillPassive + "\nskillImproves: " + skill_5.skillImproves + "\n" + "\nskillId: " + skill_6.skillId + "\nskillName: " + skill_6.skillName + "\nskillDesc: " + skill_6.skillDesc + "\nskillLink: " + skill_6.skillLink + "\nskillPassive: " + skill_6.skillPassive + "\nskillImproves: " + skill_6.skillImproves + "\n" + "\nskillId: " + skill_7.skillId + "\nskillName: " + skill_7.skillName + "\nskillDesc: " + skill_7.skillDesc + "\nskillLink: " + skill_7.skillLink + "\nskillPassive: " + skill_7.skillPassive + "\nskillImproves: " + skill_7.skillImproves + "\n" + "\nskillId: " + skill_8.skillId + "\nskillName: " + skill_8.skillName + "\nskillDesc: " + skill_8.skillDesc + "\nskillLink: " + skill_8.skillLink + "\nskillPassive: " + skill_8.skillPassive + "\nskillImproves: " + skill_8.skillImproves + "\n" + "\nskillId: " + skill_9.skillId + "\nskillName: " + skill_9.skillName + "\nskillDesc: " + skill_9.skillDesc + "\nskillLink: " + skill_9.skillLink + "\nskillPassive: " + skill_9.skillPassive + "\nskillImproves: " + skill_9.skillImproves + "\n" + "\nskillId: " + skill_10.skillId + "\nskillName: " + skill_10.skillName + "\nskillDesc: " + skill_10.skillDesc + "\nskillLink: " + skill_10.skillLink + "\nskillPassive: " + skill_10.skillPassive + "\nskillImproves: " + skill_10.skillImproves + "\n" + "\nskillId: " + skill_11.skillId + "\nskillName: " + skill_11.skillName + "\nskillDesc: " + skill_11.skillDesc + "\nskillLink: " + skill_11.skillLink + "\nskillPassive: " + skill_11.skillPassive + "\nskillImproves: " + skill_11.skillImproves + "\n" + "\nskillId: " + skill_12.skillId + "\nskillName: " + skill_12.skillName + "\nskillDesc: " + skill_12.skillDesc + "\nskillLink: " + skill_12.skillLink + "\nskillPassive: " + skill_12.skillPassive + "\nskillImproves: " + skill_12.skillImproves;
      }
      
      public function getOnlineUsers() : void
      {
         var _loc3_:User = null;
         var _loc1_:Vector.<User> = EpicDuel.smartFox.getActiveRoom().getUserList();
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            if(CurrentUser.instance._myAvatar != null)
            {
               _loc2_.push("charName: " + _loc3_.charName + "\nsfsUserId: " + _loc3_.getId() + "\ndbUserId: " + _loc3_.userId + "\ncharId: " + _loc3_.charId + "\nfctName: " + _loc3_.fctName + "\nfctId: " + _loc3_.fctId + "\n");
            }
         }
         return this.ui.comment_txt.text = _loc2_;
      }
      
      public function famePlayers() : void
      {
         var _loc6_:Object = null;
         _loc6_ = {};
         var _loc3_:User = null;
         var _loc1_:Vector.<User> = EpicDuel.smartFox.getActiveRoom().getUserList();
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            if(CurrentUser.instance._myAvatar != null)
            {
               _loc2_.push(_loc3_.charId);
            }
         }
         _loc6_.charId = _loc2_[Math.floor(Math.random() * _loc2_.length)];
         return EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_GIVE_FAME,_loc6_,2,SmartFoxClient.XTMSG_TYPE_JSON);
      }
      
      public function changeGender() : void
      {
         var uVars:Object = null;
         var myUser:User = EpicDuel.getMyUser();
         if(myUser != null)
         {
            if(CurrentUser.instance._myAvatar != null && CurrentUser.instance._charGender == Constants.MALE)
            {
               uVars = {};
               uVars.charGender = "F";
               uVars.charClassId = Math.floor(Math.random() * 6);
               EpicDuel.setVars("saveClass",uVars);
            }
            else
            {
               uVars = {};
               uVars.charGender = "M";
               uVars.charClassId = Math.floor(Math.random() * 6);
               EpicDuel.setVars("saveClass",uVars);
            }
         }
      }
      
      public function getPlayerSkills() : void
      {
         var playerSkills:Object = null;
         playerSkills = CurrentUser.instance._playerSkills[String(uint(EpicDuel.getMyUser().userId))];
         return this.ui.comment_txt.text = playerSkills.skills;
      }
      
      public function turnToFish() : void
      {
         var note:String = "needs revision";
         var _loc2_:int = 1;
         var _loc3_:BattleActor = BattleModule.instance.getBattleActorBySlot(EpicDuel.getMyUser());
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charId: " + _loc3_._base.charId);
      }
      
      public function getEquippedItem() : void
      {
         var _loc14_:ItemRecord = null;
         _loc14_ = null;
         _loc14_ = ItemBox.instance.getItemById(EpicDuel.getMyUser().iWpn);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"itemDamage: " + _loc14_.itemDamage);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"itemCredits: " + _loc14_.itemCredits);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iWpn: " + EpicDuel.getMyUser().iWpn);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iGun: " + EpicDuel.getMyUser().iGun);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iAux: " + EpicDuel.getMyUser().iAux);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iBot: " + EpicDuel.getMyUser().iBot);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"charArm: " + EpicDuel.getMyUser().charArm);
         EpicDuel.addMessageToTextField(MainInterfaceModule.instance.ui.chat_tab.message_txt,"iVeh: " + EpicDuel.getMyUser().iVeh);
      }
      
      public function giftAnim() : void
      {
         var _loc13_:Player = EpicDuel.instance.getPlayerByUserId(EpicDuel.getMyUser().getId());
         _loc13_.addChild(new GiftAnimationGlobalUI());
      }
      
      private function sendMailToUsers() : void
      {
         var _loc3_:User = null;
         var _loc1_:Vector.<User> = EpicDuel.smartFox.getActiveRoom().getUserList();
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            if(CurrentUser.instance._myAvatar != null)
            {
               _loc2_.push(_loc3_.charId);
            }
         }
         return _loc2_[Math.floor(Math.random() * _loc2_.length)];
      }
      
      public function createMail() : void
      {
         var note:String = "needs revision";
         var _loc4_:Object = null;
         _loc4_ = {};
         _loc4_.recipients = this.sendMailToUsers();
         _loc4_.subject = "test";
         _loc4_.message = ":)";
         return EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_SEND_PLAYER_MAIL,_loc4_,2,SmartFoxClient.XTMSG_TYPE_JSON);
      }
      
      public function unpack() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 20;
         while(_loc3_ < _loc4_)
         {
            EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_OPEN_ALL_GIFTS,{},1,SmartFoxClient.XTMSG_TYPE_JSON);
            _loc3_++;
         }
      }
      
      public function spinForPinkYeti() : void
      {
         var note:String = "needs revision";
         var _loc1_:int = 0;
         var _loc3_:int = 20;
         var _loc2_:Object = {};
         _loc2_.gameId = 16;
         while(_loc1_ < _loc3_)
         {
            EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_ARCADE_SPIN,_loc2_,2,SmartFoxClient.XTMSG_TYPE_JSON);
            _loc1_++;
         }
      }
      
      public function doMissions() : void
      {
         var note:String = "needs revision";
         var _loc1_:int = Math.ceil(Math.random() * 1000);
         var _loc2_:MissionProgressObject = _myMissions[String(_loc1_)];
         if(_loc2_ == null)
         {
            _loc2_ = new MissionProgressObject(0,1);
         }
         _loc2_.missionDone = 1;
         _loc2_.missionCnt = 0;
         _myMissions[String(_loc1_)] = _loc2_;
      }
      
      public function increaseAchievementValue() : void
      {
         var note:String = "needs revision";
         var _loc5_:int = 750;
         PlayerAchievementSet.increaseAchievementValue(CurrentUser.instance._myCharId,_loc5_.achId,_loc5_.achGroup);
      }
      
      public function debugThingsHere() : void
      {
         var _loc8_:MovieClip = new GiftAnimationGlobalUI();
         _loc8_.scaleX = 0.65;
         _loc8_.scaleY = 0.65;
         var _loc9_:NotificationParams = new NotificationParams();
         _loc9_.graphic = new Window_304_97_Left_Icon("Titan: " + " hey folks ",_loc8_);
         _loc9_.xCoord = 151;
         _loc9_.yCoord = 120;
         _loc9_.secondDuration = 140;
         NotificationModule.instance.displayNotification(_loc9_);
      }
      
      public function TechMageSkills() : Array
      {
         var note:String = "Use getSkillNames() function to find the skill you want by its Skill ID";
         return [61,80,561,33];
      }
      
      public function TechMageSkillsLvl() : Array
      {
         var note:String = "These are the levels for each skill";
         return [10,2,10,10,10];
      }
      
      public function BountyHunterSkills() : Array
      {
         var note:String = "Use my getSkillNames() function to find a skill you want by its Skill ID";
         return [1,13,24,21,24];
      }
      
      public function BountyHunterSkillsLvl() : Array
      {
         var note:String = "These are the levels for each skill";
         return [10,10,10,10,2];
      }
      
      public function setStatsSkills() : void
      {
         var note:String = "continue on this later";
         var myUser:User = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc17_:Object = {};
         if(EpicDuel.getMyUser().charClassId == 1)
         {
            _loc4_ = this.BountyHunterSkills();
            _loc5_ = this.BountyHunterSkillsLvl();
            _loc17_.hp = 0;
            _loc17_.mp = 0;
            _loc17_.str = 0;
            _loc17_.dex = 0;
            _loc17_.tech = 0;
            _loc17_.supp = 0;
         }
         if(EpicDuel.getMyUser().charClassId == 3)
         {
            _loc4_ = [61,80,561,33];
            _loc5_ = [10,2,10,10,10];
            _loc17_.hp = 1000;
            _loc17_.mp = 620;
            _loc17_.str = 50;
            _loc17_.dex = 56;
            _loc17_.tech = 60;
            _loc17_.supp = 50;
         }
         _loc17_.skillIds = _loc4_;
         _loc17_.skillLvls = _loc5_;
         EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPDATE_STATS_SKILLS,_loc17_,2,SmartFoxClient.XTMSG_TYPE_JSON);
      }
      
      public function updateItemStats() : void
      {
         var note:String = "it works, though needs revision";
         var _loc4_:InventoryListItem = null;
         _loc4_ = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iWpn);
         var _loc5_:CharacterInvRecord = _loc4_.charInvRecord;
         _loc5_.damage = 350;
         _loc5_.defense = 0;
         _loc5_.resist = 0;
         _loc5_.strAdd = 20;
         _loc5_.dexAdd = 5;
         _loc5_.techAdd = 3;
         _loc5_.suppAdd = 0;
         StatsSkillsModule.instance.updateStats(new StatsParams());
         InventoryModule.instance.updateStatEditor();
      }
      
      public function setItemStats() : void
      {
         var note:String = "check this later";
         var myUser:User = null;
         var itemStats:Object = null;
         itemStats = {};
         itemStats.iGun = EpicDuel.getMyUser().iGun;
         itemStats.gunStrAdd = 20;
         itemStats.gunDexAdd = 0;
         itemStats.gunTechAdd = 0;
         itemStats.gunSuppAdd = 1;
         itemStats.gunDmg = 350;
         myUser.setVariables(itemStats);
      }
      
      public function upgradeItem() : void
      {
         var note:String = "works";
         var _loc2_:Object = {};
         var _loc4_:InventoryListItem = null;
         _loc4_ = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iWpn);
         var _loc3_:CharacterInvRecord = _loc4_.charInvRecord;
         _loc2_.payMode = 1;
         _loc2_.invId = _loc3_.charInvId;
         _loc2_.dmg = 130;
         _loc2_.def = 0;
         _loc2_.res = 0;
         _loc2_.str = 4;
         _loc2_.dex = 0;
         _loc2_.tech = 0;
         _loc2_.supp = 0;
         _loc2_.pCredits = 1075;
         _loc2_.pVarium = 65;
         _loc2_.bCredits = Currency.credits;
         _loc2_.bVarium = Currency.varium;
         EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc2_,1,SmartFoxClient.XTMSG_TYPE_JSON);
      }
      
      public function getBasicItems() : void
      {
         var basicItem:Array = [4,6,31,1889,1890];
         var itemList:Array = basicItem;
         var pickedItem:int = itemList[Math.floor(Math.random() * itemList.length)];
         var _loc3_:Object = {};
         _loc3_.itemId = pickedItem;
         _loc3_.merchId = 6;
         _loc3_.buyMode = 1;
         _loc3_.dmg = 110;
         _loc3_.def = 0;
         _loc3_.res = 0;
         _loc3_.str = 1;
         _loc3_.dex = 0;
         _loc3_.tech = 0;
         _loc3_.supp = 0;
         _loc3_.buyback = 0;
         _loc3_.bCredits = Currency.credits;
         _loc3_.bVarium = Currency.varium;
         _loc3_.pCredits = 150;
         _loc3_.pVarium = 10;
         EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_BUY_ITEM,_loc3_,1,SmartFoxClient.XTMSG_TYPE_JSON);
      }
      
      public function buyItem() : void
      {
         var pickedItem:int = 4767;
         var _loc3_:Object = {};
         _loc3_.itemId = pickedItem;
         _loc3_.merchId = 327;
         _loc3_.buyMode = 1;
         _loc3_.dmg = 175;
         _loc3_.def = 0;
         _loc3_.res = 0;
         _loc3_.str = 5;
         _loc3_.dex = 5;
         _loc3_.tech = 5;
         _loc3_.supp = 4;
         _loc3_.buyback = 0;
         _loc3_.bCredits = Currency.credits;
         _loc3_.bVarium = Currency.varium;
         _loc3_.pCredits = 250000;
         _loc3_.pVarium = 0;
         EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_BUY_ITEM,_loc3_,1,SmartFoxClient.XTMSG_TYPE_JSON);
      }
      
      public function getAllMerchantId() : void
      {
         var _loc3_:MerchantRecord = MerchantBox.instance.getMerchantById(this.ui.comment_txt.text);
         return this.ui.comment_txt.text = _loc3_.mercName + " (" + _loc3_.merchLvl + ") " + " (" + _loc3_.reqItems + ")";
      }
      
      public function maxStrStats() : void
      {
         var note:String = "works but cant run simultaneously";
         var timer:Timer = null;
         var _loc3_:CharacterInvRecord = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc8_:CharacterInvRecord = null;
         var _loc9_:CharacterInvRecord = null;
         var Primary:InventoryListItem = null;
         var Aux:InventoryListItem = null;
         var Sidearm:InventoryListItem = null;
         var Armour:InventoryListItem = null;
         var _loc2_:Object = null;
         var _loc5_:Object = null;
         var _loc7_:Object = null;
         var _loc10_:Object = null;
         if(EpicDuel.getMyUser().iWpn != -1)
         {
            _loc2_ = {};
            Primary = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iWpn);
            _loc3_ = Primary.charInvRecord;
            _loc2_.payMode = 1;
            _loc2_.invId = _loc3_.charInvId;
            _loc2_.dmg = 360;
            _loc2_.def = 0;
            _loc2_.res = 0;
            _loc2_.str = 28;
            _loc2_.dex = 0;
            _loc2_.tech = 0;
            _loc2_.supp = 0;
            _loc2_.pCredits = 100;
            _loc2_.pVarium = 0;
            _loc2_.bCredits = Currency.credits;
            _loc2_.bVarium = Currency.varium;
            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc2_,1,SmartFoxClient.XTMSG_TYPE_JSON));
            timer.start();
         }
         if(EpicDuel.getMyUser().iAux != -1)
         {
            _loc5_ = {};
            Aux = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iAux);
            _loc6_ = Aux.charInvRecord;
            _loc5_.payMode = 1;
            _loc5_.invId = _loc6_.charInvId;
            _loc5_.dmg = 400;
            _loc5_.def = 0;
            _loc5_.res = 0;
            _loc5_.str = 21;
            _loc5_.dex = 0;
            _loc5_.tech = 0;
            _loc5_.supp = 0;
            _loc5_.pCredits = 100;
            _loc5_.pVarium = 0;
            _loc5_.bCredits = Currency.credits;
            _loc5_.bVarium = Currency.varium;
            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
            timer.start();
         }
         if(EpicDuel.getMyUser().iGun != -1)
         {
            _loc7_ = {};
            Sidearm = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iGun);
            _loc8_ = Sidearm.charInvRecord;
            _loc7_.payMode = 1;
            _loc7_.invId = _loc8_.charInvId;
            _loc7_.dmg = 350;
            _loc7_.def = 0;
            _loc7_.res = 0;
            _loc7_.str = 21;
            _loc7_.dex = 0;
            _loc7_.tech = 0;
            _loc7_.supp = 0;
            _loc7_.pCredits = 100;
            _loc7_.pVarium = 0;
            _loc7_.bCredits = Currency.credits;
            _loc7_.bVarium = Currency.varium;
            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc7_,1,SmartFoxClient.XTMSG_TYPE_JSON));
            timer.start();
         }
         if(EpicDuel.getMyUser().charArm != -1)
         {
            _loc10_ = {};
            Armour = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().charArm);
            _loc9_ = Armour.charInvRecord;
            _loc10_.payMode = 1;
            _loc10_.invId = _loc9_.charInvId;
            _loc10_.dmg = 0;
            _loc10_.def = 60;
            _loc10_.res = 60;
            _loc10_.str = 24;
            _loc10_.dex = 0;
            _loc10_.tech = 0;
            _loc10_.supp = 0;
            _loc10_.pCredits = 100;
            _loc10_.pVarium = 0;
            _loc10_.bCredits = Currency.credits;
            _loc10_.bVarium = Currency.varium;
            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc10_,1,SmartFoxClient.XTMSG_TYPE_JSON));
            timer.start();
         }
      }
      
      public function resetAuxStats() : void
      {
         var note:String = "Add your main stats here which you wish to revert to";
         var timer:Timer = null;
         var Aux:InventoryListItem = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc5_:Object = null;
         _loc5_ = {};
         Aux = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iAux);
         _loc6_ = Aux.charInvRecord;
         _loc5_.payMode = 1;
         _loc5_.invId = _loc6_.charInvId;
         _loc5_.dmg = 400;
         _loc5_.def = 0;
         _loc5_.res = 0;
         _loc5_.str = 0;
         _loc5_.dex = 10;
         _loc5_.tech = 11;
         _loc5_.supp = 0;
         _loc5_.pCredits = 100;
         _loc5_.pVarium = 0;
         _loc5_.bCredits = Currency.credits;
         _loc5_.bVarium = Currency.varium;
         timer = new Timer(3000);
         timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
         timer.start();
      }
      
      public function changeAuxStats() : void
      {
         var timer:Timer = null;
         var Aux:InventoryListItem = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc5_:Object = null;
         _loc5_ = {};
         Aux = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iAux);
         _loc6_ = Aux.charInvRecord;
         _loc5_.payMode = 1;
         _loc5_.invId = _loc6_.charInvId;
         _loc5_.dmg = 400;
         _loc5_.def = 0;
         _loc5_.res = 0;
         _loc5_.str = 21;
         _loc5_.dex = 0;
         _loc5_.tech = 0;
         _loc5_.supp = 0;
         _loc5_.pCredits = 100;
         _loc5_.pVarium = 0;
         _loc5_.bCredits = Currency.credits;
         _loc5_.bVarium = Currency.varium;
         timer = new Timer(3000);
         timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
         timer.start();
      }
      
      public function resetGunStats() : void
      {
         var note:String = "Add your main stats here which you wish to revert to";
         var timer:Timer = null;
         var Sidearm:InventoryListItem = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc5_:Object = null;
         _loc5_ = {};
         Sidearm = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iGun);
         _loc6_ = Sidearm.charInvRecord;
         _loc5_.payMode = 1;
         _loc5_.invId = _loc6_.charInvId;
         _loc5_.dmg = 350;
         _loc5_.def = 0;
         _loc5_.res = 0;
         _loc5_.str = 0;
         _loc5_.dex = 10;
         _loc5_.tech = 11;
         _loc5_.supp = 0;
         _loc5_.pCredits = 100;
         _loc5_.pVarium = 0;
         _loc5_.bCredits = Currency.credits;
         _loc5_.bVarium = Currency.varium;
         timer = new Timer(3000);
         timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
         timer.start();
      }
      
      public function changeGunStats() : void
      {
         var timer:Timer = null;
         var Sidearm:InventoryListItem = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc5_:Object = null;
         _loc5_ = {};
         Sidearm = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iGun);
         _loc6_ = Sidearm.charInvRecord;
         _loc5_.payMode = 1;
         _loc5_.invId = _loc6_.charInvId;
         _loc5_.dmg = 350;
         _loc5_.def = 0;
         _loc5_.res = 0;
         _loc5_.str = 21;
         _loc5_.dex = 0;
         _loc5_.tech = 0;
         _loc5_.supp = 0;
         _loc5_.pCredits = 100;
         _loc5_.pVarium = 0;
         _loc5_.bCredits = Currency.credits;
         _loc5_.bVarium = Currency.varium;
         timer = new Timer(3000);
         timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
         timer.start();
      }
      
      public function resetPrimaryStats() : void
      {
         var note:String = "Add your main stats here which you wish to revert to";
         var timer:Timer = null;
         var Primary:InventoryListItem = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc5_:Object = null;
         _loc5_ = {};
         Primary = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iWpn);
         _loc6_ = Primary.charInvRecord;
         _loc5_.payMode = 1;
         _loc5_.invId = _loc6_.charInvId;
         _loc5_.dmg = 360;
         _loc5_.def = 0;
         _loc5_.res = 0;
         _loc5_.str = 0;
         _loc5_.dex = 10;
         _loc5_.tech = 18;
         _loc5_.supp = 0;
         _loc5_.pCredits = 100;
         _loc5_.pVarium = 0;
         _loc5_.bCredits = Currency.credits;
         _loc5_.bVarium = Currency.varium;
         timer = new Timer(3000);
         timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
         timer.start();
      }
      
      public function changePrimaryStats() : void
      {
         var timer:Timer = null;
         var Primary:InventoryListItem = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc5_:Object = null;
         _loc5_ = {};
         Primary = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().iWpn);
         _loc6_ = Primary.charInvRecord;
         _loc5_.payMode = 1;
         _loc5_.invId = _loc6_.charInvId;
         _loc5_.dmg = 360;
         _loc5_.def = 0;
         _loc5_.res = 0;
         _loc5_.str = 28;
         _loc5_.dex = 0;
         _loc5_.tech = 0;
         _loc5_.supp = 0;
         _loc5_.pCredits = 100;
         _loc5_.pVarium = 0;
         _loc5_.bCredits = Currency.credits;
         _loc5_.bVarium = Currency.varium;
         timer = new Timer(3000);
         timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
         timer.start();
      }
      
      public function resetArmourStats() : void
      {
         var note:String = "Add your main stats here which you wish to revert to";
         var timer:Timer = null;
         var Armour:InventoryListItem = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc5_:Object = null;
         _loc5_ = {};
         Armour = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().charArm);
         _loc6_ = Armour.charInvRecord;
         _loc5_.payMode = 1;
         _loc5_.invId = _loc6_.charInvId;
         _loc5_.dmg = 0;
         _loc5_.def = 80;
         _loc5_.res = 40;
         _loc5_.str = 0;
         _loc5_.dex = 10;
         _loc5_.tech = 14;
         _loc5_.supp = 0;
         _loc5_.pCredits = 100;
         _loc5_.pVarium = 0;
         _loc5_.bCredits = Currency.credits;
         _loc5_.bVarium = Currency.varium;
         timer = new Timer(3000);
         timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
         timer.start();
      }
      
      public function changeArmourStats() : void
      {
         var timer:Timer = null;
         var Armour:InventoryListItem = null;
         var _loc6_:CharacterInvRecord = null;
         var _loc5_:Object = null;
         _loc5_ = {};
         Armour = InventoryModule.instance.getInventoryItemByItemId(EpicDuel.getMyUser().charArm);
         _loc6_ = Armour.charInvRecord;
         _loc5_.payMode = 1;
         _loc5_.invId = _loc6_.charInvId;
         _loc5_.dmg = 0;
         _loc5_.def = 120;
         _loc5_.res = 0;
         _loc5_.str = 24;
         _loc5_.dex = 0;
         _loc5_.tech = 0;
         _loc5_.supp = 0;
         _loc5_.pCredits = 100;
         _loc5_.pVarium = 0;
         _loc5_.bCredits = Currency.credits;
         _loc5_.bVarium = Currency.varium;
         timer = new Timer(3000);
         timer.addEventListener(TimerEvent.TIMER,EpicDuel.smartFox.sendXtMessage("main",Requests.REQUEST_UPGRADE_ITEM,_loc5_,1,SmartFoxClient.XTMSG_TYPE_JSON));
         timer.start();
      }
      
      public function change_stats_to_strength() : void
      {
         this.changeArmourStats();
         this.changePrimaryStats();
         this.changeGunStats();
         this.changeAuxStats();
      }
      
      public function reset_stats() : void
      {
         this.resetArmourStats();
         this.resetPrimaryStats();
         this.resetGunStats();
         this.resetAuxStats();
      }
      
      private function reportPlayerHandler(param1:MouseEvent) : void
      {
         var note:String = "";
         var _loc4_:String = this.ui.comment_txt.text;
         var _loc5_:String = null;
         _loc5_ = _loc4_.toLowerCase();
         if(_loc5_ == "/playerinfo")
         {
            this.grabPlayerInfo();
         }
         if(_loc5_ == "/vars")
         {
            this.getVars();
         }
         if(_loc5_ == "/getskills")
         {
            this.getAllSkillNames();
         }
         if(_loc5_ == "/onlineusers")
         {
            this.getOnlineUsers();
         }
         if(_loc5_ == "/fame")
         {
            this.famePlayers();
         }
         if(_loc5_ == "/gender")
         {
            this.changeGender();
         }
         if(_loc5_ == "/playerskills")
         {
            this.getPlayerSkills();
         }
         if(_loc5_ == "/fish")
         {
            this.turnToFish();
         }
         if(_loc5_ == "/animation")
         {
            this.giftAnim();
         }
         if(_loc5_ == "/mail")
         {
            this.createMail();
         }
         if(_loc5_)
         {
            EpicDuel.joinRoom(this.ui.comment_txt.text);
         }
         if(_loc5_ == "delete this ")
         {
            EpicDuel.instance.jumpToRoomConfirm(this.ui.comment_txt.text);
         }
         if(_loc5_ == "/remove")
         {
            EnvironmentForeground.instance.removeForeground();
            EnvironmentObjects.instance.removeObjects();
            EnvironmentHotSpots.instance.removeHotSpots();
            EnvironmentWalls.instance.removeWalls();
            EnvironmentAnimate.instance.removeAnimate();
            EnvironmentBackdrop.instance.removeBackdrop();
         }
         if(_loc5_ == "/opengifts")
         {
            this.unpack();
         }
         if(_loc5_ == "/missions")
         {
            this.doMissions();
         }
         if(_loc5_ == "/spinforyeti")
         {
            this.spinForPinkYeti();
         }
         if(_loc5_ == "/send")
         {
            this.sendNotification();
         }
         if(_loc5_ == "/fish")
         {
            CharacterBase.instance.convertPrimaryToFish();
         }
         if(_loc5_ == "/itemid")
         {
            this.getEquippedItem();
         }
         if(_loc5_ == "/setstats")
         {
            this.setStatsSkills();
         }
         if(_loc5_ == "/update")
         {
            this.updateItemStats();
         }
         if(_loc5_ == "/set")
         {
            this.setItemStats();
         }
         if(_loc5_ == "/upgrade")
         {
            this.upgradeItem();
         }
         if(_loc5_ == "/basic")
         {
            this.getBasicItems();
         }
         if(_loc5_ == "remove this to test")
         {
            this.getAllMerchantId();
         }
         if(_loc5_ == "/buy")
         {
            this.buyItem();
         }
         if(_loc5_ == "/str")
         {
            note = "works, though it cant perform simultaneously";
            this.maxStrStats();
         }
         if(_loc5_ == "/str2")
         {
            this.change_stats_to_strength();
         }
         if(_loc5_ == "/reset")
         {
            this.reset_stats();
         }
      }
   }
}
