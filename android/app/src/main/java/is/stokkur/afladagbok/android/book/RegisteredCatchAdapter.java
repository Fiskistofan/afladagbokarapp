/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Stokkur Software ehf.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package is.stokkur.afladagbok.android.book;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.FishAndAnimalCatch;
import is.stokkur.afladagbok.android.utils.SpeciesID;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 12/11/17.
 */

public class RegisteredCatchAdapter extends RecyclerView.Adapter<RegisteredCatchAdapter.RegisteredCatchViewHolder> {

    private List<FishAndAnimalCatch> registeredCatch;
    private Context context;
    private ChangeRegistryClickListener listener;

    public RegisteredCatchAdapter(List<FishAndAnimalCatch> registeredFish, Context context) {
        this.registeredCatch = registeredFish;
        this.context = context;
    }

    @Override
    public RegisteredCatchViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.registered_catch_item, parent, false);
        RegisteredCatchViewHolder viewHolder = new RegisteredCatchViewHolder(view);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(RegisteredCatchViewHolder holder, int position) {
        holder.fishName.setText(String.valueOf(registeredCatch.get(position).getSpeciesName()));
        holder.registeredTime.setText(context.getResources().getString(R.string.registered_time, Utils.getTime(registeredCatch.get(position).getRegistryDate())));
        holder.changeRegistryButton.setOnClickListener(v -> listener.changeRegistry(registeredCatch.get(position).getCatchId()));
        if (registeredCatch.get(position).isSmallFish()) {
            holder.extraInfo.setText(R.string.extra_info_catch_yes);
        } else {
            holder.extraInfo.setText(R.string.extra_info_catch_no);
        }
        if (registeredCatch.get(position).getSpeciesId() == SpeciesID.LUDA || registeredCatch.get(position).getSpeciesId() == SpeciesID.LUDA_2 || registeredCatch.get(position).getSpeciesId() == SpeciesID.LUDA_3) {
            if (registeredCatch.get(position).isReleased()) {
                holder.extraInfo.setText(R.string.extra_info_released);
            } else {
                holder.extraInfo.setText(R.string.extra_info_landed);
            }
        }

        switch (registeredCatch.get(position).getSpeciesType()) {
            case SpeciesID.FISH:
                holder.catchIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fish));
                holder.fishWeight.setText(context.getResources().getString(R.string.fish_catch_kg, registeredCatch.get(position).getWeight()));
                break;
            case SpeciesID.OTHER:
                holder.catchIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_mammal_small));
                holder.fishWeight.setText(context.getResources().getString(R.string.animal_catch_amount, (int) registeredCatch.get(position).getWeight()));
                break;
            default:
                holder.catchIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fish));
                holder.fishWeight.setText(context.getResources().getString(R.string.fish_catch_kg, registeredCatch.get(position).getWeight()));
                break;
        }
    }

    @Override
    public int getItemCount() {
        return registeredCatch.size();
    }

    public void setListener(ChangeRegistryClickListener listener) {
        this.listener = listener;
    }

    public class RegisteredCatchViewHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.fish_name)
        TextView fishName;
        @BindView(R.id.fish_weight)
        TextView fishWeight;
        @BindView(R.id.registered_time)
        TextView registeredTime;
        @BindView(R.id.catch_icon)
        ImageView catchIcon;
        @BindView(R.id.extra_info)
        TextView extraInfo;
        @BindView(R.id.change_registry_button)
        Button changeRegistryButton;

        public RegisteredCatchViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }
}
