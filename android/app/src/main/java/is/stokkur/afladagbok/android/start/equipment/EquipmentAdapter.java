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

package is.stokkur.afladagbok.android.start.equipment;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.FishingEquipments;

/**
 * Created by annalaufey on 11/29/17.
 */

public class EquipmentAdapter
        extends RecyclerView.Adapter<EquipmentAdapter.EquipmentViewHolder> {

    final private List<FishingEquipments> equipments;
    final private Context context;
    final private LayoutInflater mInflater;
    final private FishingEquipmentTypeListener mListener;
    final private int mPreferredEquipmentId;

    EquipmentAdapter(List<FishingEquipments> equipments,
                     Context context,
                     FishingEquipmentTypeListener listener,
                     int preferredEquipmentId) {
        this.equipments = equipments;
        this.context = context;
        mInflater = LayoutInflater.from(context);
        mListener = listener;
        mPreferredEquipmentId = preferredEquipmentId;
    }

    @Override
    public EquipmentViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new EquipmentViewHolder(mInflater.inflate(R.layout.equipment_item, parent, false));
    }

    @Override
    public void onBindViewHolder(EquipmentViewHolder holder, int position) {
        holder.bindTo(equipments.get(position));
    }

    @Override
    public int getItemCount() {
        return equipments.size();
    }

    public class EquipmentViewHolder
            extends RecyclerView.ViewHolder
            implements View.OnClickListener {

        final private TextView equipmentName;
        final private ImageView equipmentIcon;
        final private TextView mPreferredEquipment;

        private FishingEquipments mEquipment = null;

        public EquipmentViewHolder(View itemView) {
            super(itemView);
            equipmentName = itemView.findViewById(R.id.equipment_name);
            equipmentIcon = itemView.findViewById(R.id.equipment_icon);
            mPreferredEquipment = itemView.findViewById(R.id.equipment_preferred);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            mListener.onTypeSelected(mEquipment);
        }

        void bindTo(FishingEquipments equipment) {
            mEquipment = equipment;
            equipmentName.setText(equipment.getName());
            String type = equipment.getType();
            if (type.compareTo(FishingEquipments.HAND) == 0) {
                equipmentIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fishinghook, null));
            } else if (type.compareTo(FishingEquipments.LINE) == 0) {
                equipmentIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fishingline, null));
            } else if (type.compareTo(FishingEquipments.NET) == 0) {
                equipmentIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_net, null));
            } else {
                equipmentIcon.setImageResource(0);
            }
            mPreferredEquipment.setVisibility(equipment.getId() == mPreferredEquipmentId ?
                    View.VISIBLE : View.GONE);
        }
    }

    public interface FishingEquipmentTypeListener {

        void onTypeSelected(FishingEquipments equipment);

    }

}
