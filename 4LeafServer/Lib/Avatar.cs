using System;
using System.Collections.Generic;

namespace _4LeafServer
{
    public class Avatar : IDisposable
    {
        ~Avatar()
        { Dispose(false); }

        public void Dispose()
        {
            try
            {
                Dispose(true);

                GC.SuppressFinalize(this);
            }
            catch
            { throw; }
        }
        private bool _alreadyDisposed = false;
        protected virtual void Dispose(bool inDisposing)
        {
            if (_alreadyDisposed == true)
            {
                return;
            }

            if (inDisposing == true)
            {
                // managed resource
            }

            _alreadyDisposed = true;
        }

        /*
        {
            case 0:
                nsAvatar.BodyBack = 2;
                nsAvatar.BodyFront = 22;
                nsAvatar.Hair = 484;
                nsAvatar.Clothes = 1004;
                nsAvatar.Trousers = 1005;
                nsAvatar.Shoes = 1006;
                break;
            case 1:
                nsAvatar.BodyBack = 2;
                nsAvatar.BodyFront = 55;
                nsAvatar.Hair = 485;
                nsAvatar.Clothes = 1004;
                nsAvatar.Trousers = 1005;
                nsAvatar.Shoes = 1006;
                break;
            case 2:
                nsAvatar.BodyBack = 2;
                nsAvatar.BodyFront = 88;
                nsAvatar.Hair = 486;
                nsAvatar.Clothes = 1004;
                nsAvatar.Trousers = 1005;
                nsAvatar.Shoes = 1006;
                break;
            case 3:
                nsAvatar.BodyBack = 2;
                nsAvatar.BodyFront = 121;
                nsAvatar.Hair = 487;
                nsAvatar.Clothes = 1004;
                nsAvatar.Trousers = 1005;
                nsAvatar.Shoes = 1006;
                break;
            case 4:
                nsAvatar.BodyBack = 2;
                nsAvatar.BodyFront = 187;
                nsAvatar.Hair = 488;
                nsAvatar.Clothes = 1004;
                nsAvatar.Trousers = 1005;
                nsAvatar.Shoes = 1006;
                break;
            case 5:
                nsAvatar.BodyBack = 2;
                nsAvatar.BodyFront = 220;
                nsAvatar.Hair = 489;
                nsAvatar.Clothes = 1004;
                nsAvatar.Trousers = 1005;
                nsAvatar.Shoes = 1006;
                break;
            case 6:
                nsAvatar.BodyBack = 2;
                nsAvatar.BodyFront = 2;
                nsAvatar.Hair = 490;
                nsAvatar.Clothes = 1004;
                nsAvatar.Trousers = 1005;
                nsAvatar.Shoes = 1006;
                break;
            case 128:
                nsAvatar.BodyBack = 3;
                nsAvatar.BodyFront = 253;
                nsAvatar.Hair = 491;
                nsAvatar.Clothes = 1007;
                nsAvatar.Trousers = 1008;
                nsAvatar.Shoes = 1009;
                break;
            case 129:
                nsAvatar.BodyBack = 3;
                nsAvatar.BodyFront = 286;
                nsAvatar.Hair = 492;
                nsAvatar.Clothes = 1007;
                nsAvatar.Trousers = 1008;
                nsAvatar.Shoes = 1009;
                break;
            case 130:
                nsAvatar.BodyBack = 3;
                nsAvatar.BodyFront = 319;
                nsAvatar.Hair = 493;
                nsAvatar.Clothes = 1007;
                nsAvatar.Trousers = 1008;
                nsAvatar.Shoes = 1009;
                break;
            case 131:
                nsAvatar.BodyBack = 3;
                nsAvatar.BodyFront = 352;
                nsAvatar.Hair = 494;
                nsAvatar.Clothes = 1007;
                nsAvatar.Trousers = 1008;
                nsAvatar.Shoes = 1009;
                break;
            case 132:
                nsAvatar.BodyBack = 3;
                nsAvatar.BodyFront = 385;
                nsAvatar.Hair = 495;
                nsAvatar.Clothes = 1007;
                nsAvatar.Trousers = 1008;
                nsAvatar.Shoes = 1009;
                break;
            case 133:
                nsAvatar.BodyBack = 3;
                nsAvatar.BodyFront = 418;
                nsAvatar.Hair = 496;
                nsAvatar.Clothes = 1007;
                nsAvatar.Trousers = 1008;
                nsAvatar.Shoes = 1009;
                break;
            case 134:
                nsAvatar.BodyBack = 3;
                nsAvatar.BodyFront = 451;
                nsAvatar.Hair = 497;
                nsAvatar.Clothes = 1007;
                nsAvatar.Trousers = 1008;
                nsAvatar.Shoes = 1009;
                break;
        }
         * */

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
        public List<Inven> Inventory = null;
        public DateTime AccessTime;
        public DateTime Regdate;

        public ulong AccountID { get; set; }
        public ulong UID { get; set; }
        public int TID { get; set; }
        public int AOrder { get; set; }
        public int GP { get; set; }
        public int FP { get; set; }
        public int BodyBack { get; set; }
        public int BodyFront { get; set; }
        public int Hair { get; set; }
        public int HairAcc { get; set; }
        public int Clothes { get; set; }
        public int Clothes2 { get; set; }
        public int Clothes3 { get; set; }
        public int Trousers { get; set; }
        public int Trousers2 { get; set; }
        public int Trousers3 { get; set; }
        public int Shoes { get; set; }
        public int RHand { get; set; }
        public int LHand { get; set; }
        public int Acc1 { get; set; }
        public int Acc2 { get; set; }
        public int Acc3 { get; set; }
        public int Acc4 { get; set; }
        public int Acc5 { get; set; }
    }
}
