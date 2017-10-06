using NSLib;
using System;
using System.Collections.Generic;

namespace LeafServer
{
    public class AvatarModel : DisposeClass
    {
        public AvatarModel()
        {
            Clothes = new List<UInt16>();
            Pants = new List<UInt16>();
            Weapone = new List<UInt16>();
            Accessory = new List<UInt16>();
        }

        ~AvatarModel()
        { Dispose(); }

        /// <Charecter>
        ///루시안       -00 : 0
        ///조슈아       -01 : 1
        ///막시민       -02 : 2
        ///보리스       -03 : 3
        ///란지에       -04 : 4
        ///시벨린       -05 : 5
        ///이자크       -06 : 6
        ///이스핀       -80 : 128
        ///티치엘       -81 : 129
        ///클로에       -82 : 130
        ///나야트레이   -83 : 131
        ///아나이스     -84 : 132
        ///밀라         -85 : 133
        ///벤야         -86 : 134
        ///</Charecter>

        public string Name = null;
        public string Knight = null;
        public List<InvenModel> Inven = null;

        public UInt32 GP { get; set; }
        public UInt32 FP { get; set; }

        public UInt64 UID { get; set; }
        public UInt16 CID { get; set; }
        public byte Order { get; set; }

        public UInt16 Hair { get; set; }
        public UInt16 HairAcc { get; set; }
        public UInt16 Shoes { get; set; }

        // TODO : 각 컬럼 배열 구조에 넣는 기능 추가
        public List<UInt16> Clothes { get; set; }
        public List<UInt16> Pants { get; set; }
        public List<UInt16> Weapone { get; set; }
        public List<UInt16> Accessory { get; set; }

        public void InitContume()
        {
            #region 기본 머리모양
            switch (CID)
            {
                case 0:
                    Hair = 484;
                    break;
                case 1:
                    Hair = 485;
                    break;
                case 2:
                    Hair = 486;
                    break;
                case 3:
                    Hair = 487;
                    break;
                case 4:
                    Hair = 488;
                    break;
                case 5:
                    Hair = 489;
                    break;
                case 6:
                    Hair = 490;
                    break;
                case 128:
                    Hair = 491;
                    break;
                case 129:
                    Hair = 492;
                    break;
                case 130:
                    Hair = 493;
                    break;
                case 131:
                    Hair = 494;
                    break;
                case 132:
                    Hair = 495;
                    break;
                case 133:
                    Hair = 496;
                    break;
                case 134:
                    Hair = 497;
                    break;
            }

            #endregion
        }

        public void SetCostume(bool[] inCheckedInven)
        {
            InitContume();

            for (int i = 0; i < 32; i++)
            {
                if (inCheckedInven[i])
                {
                    ItemModel objItem = DataContainer.FindItem(Inven[i - 2].ItemIndex);
                    switch (objItem.Mount)
                    {
                        case 3: // 헤어
                            Hair = objItem.Index;
                            break;
                        case 4: // 헤어 악세사리
                            HairAcc = objItem.Index;
                            break;
                        case 5: // 상의
                            Clothes.Add(objItem.Index);
                            break;
                        case 6: // 하의
                            Pants.Add(objItem.Index);
                            break;
                        case 7: // 신발
                            Shoes = objItem.Index;
                            break;
                        case 8: // 무기
                            Weapone.Add(objItem.Index);
                            break;
                        case 9: // 악세사리
                            Accessory.Add(objItem.Index);
                            break;
                    }
                }
            }
        }

        public void SetEquipment(List<EquipmentModel> objModel)
        {
            var EquipModel = objModel.FindAll(r => r.Order == Order);

            if (EquipModel.Exists(r => r.Mount == 3))
                Hair = EquipModel.Find(r => r.Mount == 3).EquipId;
            if (EquipModel.Exists(r => r.Mount == 4))
                HairAcc = EquipModel.Find(r => r.Mount == 4).EquipId;

            if (EquipModel.Exists(r => r.Mount == 5))
            {
                foreach (var objEquip in EquipModel.FindAll(r => r.Mount == 5))
                    Clothes.Add(objEquip.EquipId);
            }

            if (EquipModel.Exists(r => r.Mount == 6))
            {
                foreach (var objEquip in EquipModel.FindAll(r => r.Mount == 6))
                    Pants.Add(objEquip.EquipId);
            }

            if (EquipModel.Exists(r => r.Mount == 7))
                Shoes = EquipModel.Find(r => r.Mount == 7).EquipId;

            if (EquipModel.Exists(r => r.Mount == 8))
            {
                foreach (var objEquip in EquipModel.FindAll(r => r.Mount == 8))
                    Weapone.Add(objEquip.EquipId);
            }

            if (EquipModel.Exists(r => r.Mount == 9))
            {
                foreach (var objEquip in EquipModel.FindAll(r => r.Mount == 9))
                    Accessory.Add(objEquip.EquipId);
            }
        }
    }

    public class EquipmentModel : DisposeClass
    {
        ~EquipmentModel()
        { Dispose(); }

        public UInt64 UID { get; set; }
        public byte Order { get; set; }
        public UInt16 EquipId { get; set; }
        public byte Mount { get; set; }
    }
}
