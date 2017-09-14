using System.Collections.Generic;

namespace LeafServer
{
    public class AvatarModel : DisposeClass
    {
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

        public string CharacterName = null;
        public string Knights = null;
        public List<InvenModel> Inven = null;

        public int GP { get; set; }
        public int FP { get; set; }

        public ulong UID { get; set; }
        public int CID { get; set; }
        public int Order { get; set; }
        public int Hair { get; set; }
        public int HairAcc { get; set; }
        public int Clothes { get; set; }
        public int Clothes2 { get; set; }
        public int Clothes3 { get; set; }
        public int Pants { get; set; }
        public int Pants2 { get; set; }
        public int Pants3 { get; set; }
        public int Shoes { get; set; }
        public int Weapone { get; set; }
        public int Weapone2 { get; set; }
        public int Weapone3 { get; set; }
        public int Acc1 { get; set; }
        public int Acc2 { get; set; }
        public int Acc3 { get; set; }
        public int Acc4 { get; set; }
        public int Acc5 { get; set; }
        public int Acc6 { get; set; }
        public int Acc7 { get; set; }
        public int Acc8 { get; set; }

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

            HairAcc = 0;
            Clothes = 0;
            Clothes2 = 0;
            Clothes3 = 0;
            Pants = 0;
            Pants2 = 0;
            Pants3 = 0;
            Shoes = 0;
            Weapone = 0;
            Weapone2 = 0;
            Weapone3 = 0;
            Acc1 = 0;
            Acc2 = 0;
            Acc3 = 0;
            Acc4 = 0;
            Acc5 = 0;
            Acc6 = 0;
            Acc7 = 0;
            Acc8 = 0;
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
                            if (Clothes == 0)
                                Clothes = objItem.Index;
                            else if (Clothes2 == 0)
                                Clothes2 = objItem.Index;
                            else if (Clothes3 == 0)
                                Clothes3 = objItem.Index;
                            break;
                        case 6: // 하의
                            if (Pants == 0)
                                Pants = objItem.Index;
                            else if (Pants2 == 0)
                                Pants2 = objItem.Index;
                            else if (Pants3 == 0)
                                Pants3 = objItem.Index;
                            break;
                        case 7: // 신발
                            Shoes = objItem.Index;
                            break;
                        case 8: // 무기
                            if (Weapone == 0)
                                Weapone = objItem.Index;
                            else if (Weapone2 == 0)
                                Weapone2 = objItem.Index;
                            else if (Weapone3 == 0)
                                Weapone3 = objItem.Index;
                            break;
                        case 9: // 악세사리
                            if (Acc1 == 0)
                                Acc1 = objItem.Index;
                            else if (Acc2 == 0)
                                Acc2 = objItem.Index;
                            else if (Acc3 == 0)
                                Acc3 = objItem.Index;
                            else if (Acc4 == 0)
                                Acc4 = objItem.Index;
                            else if (Acc5 == 0)
                                Acc5 = objItem.Index;
                            else if (Acc6 == 0)
                                Acc6 = objItem.Index;
                            else if (Acc7 == 0)
                                Acc7 = objItem.Index;
                            else if (Acc8 == 0)
                                Acc8 = objItem.Index;
                            break;
                    }
                }
            }
        }
    }
}
