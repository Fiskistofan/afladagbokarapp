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

package is.stokkur.afladagbok.android.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.models.FishingEquipments;
import is.stokkur.afladagbok.android.utils.Utils;

public class ActiveTossesAdapter extends RecyclerView.Adapter<ActiveTossesAdapter.ActiveTossesViewHolder> {

    public enum AdapterType { FOR_FINISH, FOR_BEGIN }
    public List<StoredToss> storedTosses;
    private Context context;
    private ActiveTossListener listener;
    private AdapterType adapterType = AdapterType.FOR_BEGIN;

    public ActiveTossesAdapter(List<StoredToss> storedTosses, ActiveTossListener listener, Context ctx){
        this.storedTosses = storedTosses;
        this.context = ctx;
        this.listener = listener;
    }

    public ActiveTossesAdapter(List<StoredToss> storedTosses, ActiveTossListener listener, Context ctx, AdapterType adpType ){
        this.storedTosses = storedTosses;
        this.context = ctx;
        this.listener = listener;
        this.adapterType = adpType;
    }

    @NonNull
    @Override
    public ActiveTossesViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.active_toss_item, parent, false);
        ActiveTossesViewHolder viewHolder = new ActiveTossesViewHolder(view,this.adapterType);
        viewHolder.listener = this.listener;
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull ActiveTossesAdapter.ActiveTossesViewHolder holder, int position) {
        StoredToss storedToss = storedTosses.get(position);

        holder.storedToss = storedToss;
        holder.positionId = position+1;

        switch (Utils.getTossType(storedToss)){
            case FishingEquipments.HAND:
                holder.activeTossIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fishinghook));
                break;
            case FishingEquipments.LINE:
                holder.activeTossIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fishingline));
                break;
            case FishingEquipments.NET:
                holder.activeTossIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_net_new));
                break;
        }

        String dateTimeFormatted = storedToss.getDateTime();
        Locale current = context.getResources().getConfiguration().locale;
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss", current);
        Date date;
        try {
            date = formatter.parse(storedToss.getDateTime());
            formatter = new SimpleDateFormat("dd MMMM HH:mm", current);
            dateTimeFormatted = formatter.format(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        holder.activeTossTitle.setText(context.getString(R.string.tour_toss_active_title,position+1));
        if(adapterType == AdapterType.FOR_BEGIN) {
            holder.activeTossCountInfo.setText(context.getString(R.string.tour_toss_active_count_info,storedToss.getCount()-storedToss.getPulledCount(), storedToss.getCount()));
            holder.activeTossCountInfo.setTextColor(context.getResources().getColor(R.color.dark_gray_text));
        } else {
            holder.activeTossCountInfo.setText(context.getString(R.string.tour_toss_active_count_info,storedToss.getPulledCount(), storedToss.getCount()));
            holder.arrowIcon.setVisibility(View.INVISIBLE);
            if (storedToss.getPulledCount() == 0) {
                holder.activeTossCountInfo.setTextColor(context.getResources().getColor(R.color.colorAccentNew));
            } else {
                holder.activeTossCountInfo.setTextColor(context.getResources().getColor(R.color.dark_gray_text));
            }
        }
        holder.activeTossDateInfo.setText(context.getString(R.string.tour_toss_active_date_info,dateTimeFormatted));


        //holder.activeTossInfo.setText(context.getString(R.string.tour_toss_active_info, storedToss.getCount()-storedToss.getPulledCount(), storedToss.getCount(), dateTimeFormatted));
    }

    @Override
    public int getItemCount() {
        return storedTosses.size();
    }

    public class ActiveTossesViewHolder extends RecyclerView.ViewHolder{

        @BindView(R.id.contentLayout)
        ConstraintLayout contentLayout;
        @BindView(R.id.active_toss_icon)
        ImageView activeTossIcon;
        @BindView(R.id.active_toss_title)
        TextView activeTossTitle;
        @BindView(R.id.active_toss_count_info)
        TextView activeTossCountInfo;
        @BindView(R.id.active_toss_date_info)
        TextView activeTossDateInfo;
        @BindView(R.id.arrow_icon)
        ImageView arrowIcon;

        ActiveTossListener listener;
        StoredToss storedToss;
        int positionId;

        public ActiveTossesViewHolder(@NonNull View itemView, AdapterType adapterType) {
            super(itemView);
            ButterKnife.bind(this, itemView);
            if (adapterType == AdapterType.FOR_BEGIN) {
                arrowIcon.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if (listener != null) {
                            listener.onClick(storedToss, positionId);
                        }
                    }
                });
            } else {
                contentLayout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if (listener != null) {
                            listener.onClick(storedToss, positionId);
                        }
                    }
                });
            }
        }
    }

    public interface ActiveTossListener {
        void onClick(StoredToss st, int positionId);
    }

}
