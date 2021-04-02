DOOM_LEVEL=0
PLAYER_AI=0
function Auxiliary.DoomChance(p)
	return math.random()<=DOOM_LEVEL*0.1*p
end
function Auxiliary.DoomValue(p)
	if p<=0 then return p end
	if DOOM_LEVEL==0 then return 0 end
	return math.random(math.ceil(DOOM_LEVEL*0.1*p))
end
function Auxiliary.PreloadUds()
	for i=1,573 do math.random() end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		DOOM_LEVEL=Duel.AnnounceNumber(1,0,1,2,3,4,5,6,7,8,9,10)
		if DOOM_LEVEL>=0 then
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetValue(function(e)
				return math.min(1+Auxiliary.DoomValue(5),Duel.GetFieldGroupCount(0,LOCATION_DECK,0))
			end)
			Duel.RegisterEffect(e1,PLAYER_AI)
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_HAND_LIMIT)
			e1:SetValue(100)
			Duel.RegisterEffect(e1,PLAYER_AI)
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
			e1:SetValue(100)
			Duel.RegisterEffect(e1,PLAYER_AI)
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
			e1:SetCountLimit(1)
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.GetTurnPlayer()==PLAYER_AI
			end)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				if Duel.GetFieldGroupCount(PLAYER_AI,LOCATION_DECK,0)<=6 then
					local g=Duel.GetFieldGroup(PLAYER_AI,LOCATION_GRAVE+LOCATION_REMOVED,0)
					Duel.SendtoDeck(g,nil,2,REASON_RULE)
					Duel.ShuffleDeck(PLAYER_AI)
				end
				Duel.Recover(PLAYER_AI,Auxiliary.DoomValue(2000),REASON_RULE)
				--[[local e1=Effect.GlobalEffect()
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetValue(1+Auxiliary.DoomValue(10))
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,0)]]
			end)
			Duel.RegisterEffect(e1,PLAYER_AI)
			--if Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_EXTRA,0,1,nil,48905153,59822133) then
				local e1=Effect.GlobalEffect()
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
				e1:SetValue(1)
				Duel.RegisterEffect(e1,PLAYER_AI)
			--end
			local e3=Effect.GlobalEffect()
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				local tc=Duel.GetAttacker()
				return tc and tc:IsControler(PLAYER_AI)
			end)
			e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local tc=Duel.GetAttacker()
				if not tc then return end
				local atk=tc:GetAttack()
				if atk<=0 then return end
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
				e1:SetValue(Auxiliary.DoomValue(atk))
				tc:RegisterEffect(e1,true)
			end)
			Duel.RegisterEffect(e3,PLAYER_AI)
			--[[local reg=Card.RegisterEffect
			Card.RegisterEffect=function(c,e,b)
				if e:IsHasType(0x7f0) then
					local con=e:GetCondition()
					e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						return not con or con(e,tp,eg,ep,ev,re,r,rp) or (tp==PLAYER_AI and Auxiliary.DoomChance(0.8))
					end)
					local cost=e:GetCost()
					e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
						if chk==0 then return not cost or cost(e,tp,eg,ep,ev,re,r,rp,0) or (tp==PLAYER_AI and Auxiliary.DoomChance(0.7)) end
						if cost and cost(e,tp,eg,ep,ev,re,r,rp,0) and not (tp==PLAYER_AI and Auxiliary.DoomChance(0.7)) then
							cost(e,tp,eg,ep,ev,re,r,rp,1)
						end
					end)
				end
				reg(c,e,b)
			end]]
			local lp=Duel.GetLP(PLAYER_AI)
			Duel.SetLP(PLAYER_AI,lp*(1+DOOM_LEVEL*0.1))
			Duel.Draw(PLAYER_AI,math.ceil(DOOM_LEVEL*0.5),REASON_RULE)
		end
		e:Reset()
	end)
	Duel.RegisterEffect(e1,1-PLAYER_AI)
end
