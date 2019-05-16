Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06532208C5
	for <lists+linux-xfs@lfdr.de>; Thu, 16 May 2019 15:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfEPN7V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 May 2019 09:59:21 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38316 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfEPN7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 May 2019 09:59:20 -0400
Received: by mail-qt1-f196.google.com with SMTP id d13so3975280qth.5
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 06:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4W8nxk4k4MVtLI1JLQcZmk+Bl22d4lanY5c6NY2cMcc=;
        b=OBwCrG0UnU7M9wLjJDDx4X+Z+cQKjjahelx6+vbSVrUPXhlcqaPKcmEOzbLBceM8WF
         o3EaZkZLgqyhKmw7pdgCt58MSOxQfV+sfnkDpdrIw0o+85pylkRF9xo9KiQzom9xruYT
         xeCLVUuZZHPkoU+qXzlv49qakHmGvsKaW6Pey8RXrN/FpTHjLnj4OANSDffzhkz9bTQ2
         rvPPotJ6vVbCF085OKdx/wNomFWIV95FoqoiQqb2f2i4fsVI01GYpnqeylkIixbEfmP+
         AGLhisToyRdjD1Yv5spPiu1NcE6cWIDJv/9eJp0+Mk0Qc3WUOxSykR0OoZ+U4n4pZHg6
         kzYw==
X-Gm-Message-State: APjAAAW3T1iRxx8qGdoqnsLewZYiGvcgQUAKM9RsEa2yKlY9rGGkNOQk
        kZ/v5tHqv1torh6VcGbnLoks9A==
X-Google-Smtp-Source: APXvYqwNqjWbg9ip//OmA0nM3GR5PQZt9aCGRYqOitDJVOvfxjGNt2YWHJMFjse5jwjGBTbN3j6Jnw==
X-Received: by 2002:a0c:fe48:: with SMTP id u8mr39012393qvs.234.1558015159428;
        Thu, 16 May 2019 06:59:19 -0700 (PDT)
Received: from redhat.com ([185.54.206.10])
        by smtp.gmail.com with ESMTPSA id o37sm3676500qta.86.2019.05.16.06.59.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 06:59:18 -0700 (PDT)
Date:   Thu, 16 May 2019 09:59:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Pankaj Gupta <pagupta@redhat.com>, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org,
        qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, dan.j.williams@intel.com,
        zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
        jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net,
        hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu,
        adilger.kernel@dilger.ca, darrick.wong@oracle.com,
        lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com,
        jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com,
        stefanha@redhat.com, aarcange@redhat.com, david@fromorbit.com,
        cohuck@redhat.com, xiaoguangrong.eric@gmail.com,
        pbonzini@redhat.com, kilobyte@angband.pl, yuval.shaia@oracle.com,
        jstaron@google.com
Subject: Re: [PATCH v9 2/7] virtio-pmem: Add virtio pmem driver
Message-ID: <20190516095618-mutt-send-email-mst@kernel.org>
References: <20190514145422.16923-1-pagupta@redhat.com>
 <20190514145422.16923-3-pagupta@redhat.com>
 <9f6b1d8e-ef90-7d8b-56da-61a426953ba3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f6b1d8e-ef90-7d8b-56da-61a426953ba3@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 10:46:00PM +0200, David Hildenbrand wrote:
> > +	vpmem->vdev = vdev;
> > +	vdev->priv = vpmem;
> > +	err = init_vq(vpmem);
> > +	if (err) {
> > +		dev_err(&vdev->dev, "failed to initialize virtio pmem vq's\n");
> > +		goto out_err;
> > +	}
> > +
> > +	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
> > +			start, &vpmem->start);
> > +	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
> > +			size, &vpmem->size);
> > +
> > +	res.start = vpmem->start;
> > +	res.end   = vpmem->start + vpmem->size-1;
> 
> nit: " - 1;"
> 
> > +	vpmem->nd_desc.provider_name = "virtio-pmem";
> > +	vpmem->nd_desc.module = THIS_MODULE;
> > +
> > +	vpmem->nvdimm_bus = nvdimm_bus_register(&vdev->dev,
> > +						&vpmem->nd_desc);
> > +	if (!vpmem->nvdimm_bus) {
> > +		dev_err(&vdev->dev, "failed to register device with nvdimm_bus\n");
> > +		err = -ENXIO;
> > +		goto out_vq;
> > +	}
> > +
> > +	dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
> > +
> > +	ndr_desc.res = &res;
> > +	ndr_desc.numa_node = nid;
> > +	ndr_desc.flush = async_pmem_flush;
> > +	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > +	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > +	nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> > +	if (!nd_region) {
> > +		dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > +		err = -ENXIO;
> > +		goto out_nd;
> > +	}
> > +	nd_region->provider_data = dev_to_virtio(nd_region->dev.parent->parent);
> > +	return 0;
> > +out_nd:
> > +	nvdimm_bus_unregister(vpmem->nvdimm_bus);
> > +out_vq:
> > +	vdev->config->del_vqs(vdev);
> > +out_err:
> > +	return err;
> > +}
> > +
> > +static void virtio_pmem_remove(struct virtio_device *vdev)
> > +{
> > +	struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
> > +
> > +	nvdimm_bus_unregister(nvdimm_bus);
> > +	vdev->config->del_vqs(vdev);
> > +	vdev->config->reset(vdev);
> > +}
> > +
> > +static struct virtio_driver virtio_pmem_driver = {
> > +	.driver.name		= KBUILD_MODNAME,
> > +	.driver.owner		= THIS_MODULE,
> > +	.id_table		= id_table,
> > +	.probe			= virtio_pmem_probe,
> > +	.remove			= virtio_pmem_remove,
> > +};
> > +
> > +module_virtio_driver(virtio_pmem_driver);
> > +MODULE_DEVICE_TABLE(virtio, id_table);
> > +MODULE_DESCRIPTION("Virtio pmem driver");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
> > new file mode 100644
> > index 000000000000..ab1da877575d
> > --- /dev/null
> > +++ b/drivers/nvdimm/virtio_pmem.h
> > @@ -0,0 +1,60 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * virtio_pmem.h: virtio pmem Driver
> > + *
> > + * Discovers persistent memory range information
> > + * from host and provides a virtio based flushing
> > + * interface.
> > + **/
> > +
> > +#ifndef _LINUX_VIRTIO_PMEM_H
> > +#define _LINUX_VIRTIO_PMEM_H
> > +
> > +#include <linux/virtio_ids.h>
> > +#include <linux/module.h>
> > +#include <linux/virtio_config.h>
> > +#include <uapi/linux/virtio_pmem.h>
> > +#include <linux/libnvdimm.h>
> > +#include <linux/spinlock.h>
> > +
> > +struct virtio_pmem_request {
> > +	/* Host return status corresponding to flush request */
> > +	int ret;
> > +
> > +	/* command name*/
> > +	char name[16];
> 
> So ... why are we sending string commands and expect native-endianess
> integers and don't define a proper request/response structure + request
> types in include/uapi/linux/virtio_pmem.h like

passing names could be ok.
I missed the fact we return a native endian int.
Pls fix that.


> 
> struct virtio_pmem_resp {
> 	__virtio32 ret;
> }
> 
> #define VIRTIO_PMEM_REQ_TYPE_FLUSH	1
> struct virtio_pmem_req {
> 	__virtio16 type;
> }
> 
> ... and this way we also define a proper endianess format for exchange
> and keep it extensible
> 
> @MST, what's your take on this?

Extensions can always use feature bits so I don't think
it's a problem.

> 
> -- 
> 
> Thanks,
> 
> David / dhildenb
