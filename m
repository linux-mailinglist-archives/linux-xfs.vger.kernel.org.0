Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E943B63AF5
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 20:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfGISbZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 14:31:25 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:43396 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfGISbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 14:31:24 -0400
Received: by mail-qt1-f172.google.com with SMTP id w17so19511437qto.10
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2019 11:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pB9dO1YoSFCBt5VqzlZlYrCP0I0wMvKymwW5GOWPpKE=;
        b=jI8IubuELbmmKNncJfTqWmP+f9zvxt+ULoPrMyeL77bS9w8hq6YecHEc205qXD15al
         9L85FNMg9SN4XHzK4g5mkKz6lpYGJ8YIV2//WPmbS6Q/wRkdjD/BUC7Y7dZk5FUbVQ61
         AIABW8VOZ3wAPf7hDmV0DuHRLFxFG1ZDkt3aSzrD4Hi/eQ/rJO9ePJrOaJkbTEdHxt4u
         KEnrcITkTc3ZpMgx4MDYtzz17UTuuAYY7+bMPHdu+3YNLpOuu85jY+suc3zhsY87Qbcx
         kAGiv/l9M3R/sOOZHKY5k+VuhAlIayNg38swphmhtovOKnFIPwAv0SoNJhA2kAni1eTk
         0b2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pB9dO1YoSFCBt5VqzlZlYrCP0I0wMvKymwW5GOWPpKE=;
        b=IHM2JL4KqzWZsD11PWdn9jT24zcErr3ZaAlMSkkpGlmL2FX5TamN61KeIEphXJzjYe
         aN/tgtXC86OUdEDwv+6Egiw8H2r37Y45cREqfm5Ed63EIQ3JF7VDDsFkheQL2G3GBofM
         x+fPd/FzJ2DnwzDgDu6sUWtWj/EFsdpB7RStukTiYL45vVW6EoytrYTV+c1MeWwJTfCj
         iKa9INZuRgYQxN9ZBYuw63x9Zu9E2JE7+yPJlNiDiEL96TdaaLIMhARKbyqwgqD7FNVD
         pmNQe8iEpqlghFxMn/crynCRP3ZtgIdGRgT91lOnqd4jYZheJIcuwFyszJUZ0+QDP5VC
         +euQ==
X-Gm-Message-State: APjAAAWp0Zb7Jr5xYi/IqrIrvAPaiIQXS8xhBP7bumCTi/l9+OohvQBi
        nNsoQoyJJbcRF7tcORjBdacoIA==
X-Google-Smtp-Source: APXvYqzQbs8wLB91EIFIdM/HDibRu80Gnv/0PS61jRGBz092aGBNDw1iOxO5ZeHzT1FrxgFLIIEKRw==
X-Received: by 2002:a0c:91bc:: with SMTP id n57mr21158460qvn.141.1562697083769;
        Tue, 09 Jul 2019 11:31:23 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i16sm8864623qkk.1.2019.07.09.11.31.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 11:31:22 -0700 (PDT)
Message-ID: <1562697081.8510.16.camel@lca.pw>
Subject: Re: memory leaks from xfs_rw_bdev()
From:   Qian Cai <cai@lca.pw>
To:     Christoph Hellwig <hch@lst.de>
Cc:     darrick.wong@oracle.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 09 Jul 2019 14:31:21 -0400
In-Reply-To: <20190708213515.GB18177@lst.de>
References: <1562616489.8510.15.camel@lca.pw>
         <20190708213515.GB18177@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-07-08 at 23:35 +0200, Christoph Hellwig wrote:
> We actually have a discussion on that in another thread, but if you
> can easily reproduce the issue, can you test the patch below?
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 757c1d9293eb..e2148f2d5d6b 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -43,7 +43,7 @@ xfs_rw_bdev(
>  			bio_copy_dev(bio, prev);
>  			bio->bi_iter.bi_sector = bio_end_sector(prev);
>  			bio->bi_opf = prev->bi_opf;
> -			bio_chain(bio, prev);
> +			bio_chain(prev, bio);
>  
>  			submit_bio(prev);
>  		}

Yes, it works fine.
