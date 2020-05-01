Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CBF1C0E52
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 08:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgEAGlm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 02:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbgEAGll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 02:41:41 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F30BC08ED7D
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 23:41:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id v4so9134592wme.1
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 23:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=cpQ8/VzVs0qy6Coq4jsY7ccdDFl3LgDWXkhtB9YYQco=;
        b=GqsIZQEErtxp95UJWpKrQY3O4F4Sx0g6/X7lDuIF3bXx91ATcAP7/DgLZaXrIRReWa
         znotQmlfvGIU7bhOau/vG2ipCW6ay1jPpHU3dkPnfckc/TMFNyCGl5XeXfWbalOtQFX6
         gHm3zFY30ObZXefKrk/18Gy2OZL756D02eheTA1eXn1hgUUuYr/zXY5w9hicdvsi4iBD
         i020Okt4saC0RwlJrU73As1XgAjtDLrTAZicCsFsg88M5CUlGGFssxUDRySCbpKtqxbR
         BDN9qezqrIubk6PtQC5phFq9yawZi0lU9ffYH6Pj6n7nOgRjbcS5uv/clrIpOkDaYgOd
         H9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cpQ8/VzVs0qy6Coq4jsY7ccdDFl3LgDWXkhtB9YYQco=;
        b=MdtaZpP2ZPheQMIMrza7lWjR8/QXw43wJyZM506sqdDU2zGYh1yTzSY2W0Ziakptj9
         2o8xqiQaVv8utAe+QNUCiPUAziY5NDvL35y1tObpNaQlNBsVO43wkBMyvflMDxMw77LM
         Cbof+SijYQzDbNRBcLPMZGt2ZZZSzLMqHRCMYyXxV4fkNTixjF0HUAUhjlbbvjAH3Q9I
         twKhFlDGpCvJMbefPZhfn4LYjVy8KsvS8C2rmM3rXkYuPQlYkEDYxNxXqb9ZT0MDogmu
         s/RgIsFkxHoO9D1OFQEg4pwW7wiO2w1VFnPE4fVQfEsDnWI+Wqnv+GBQJDWYoOXoaon0
         UpOA==
X-Gm-Message-State: AGi0PuaN6PrYst47yz7lMvwXRZoirWC4wGr5XDUhDku7VLFNJrp9ra9r
        od+JNQHzMGTwdZu5O14s6LM1BQ==
X-Google-Smtp-Source: APiQypJhB8+PWaUoN3to5dH+glY2Sg5fXS6DS+6PXPXyjLj6QnarNlU5QbgDxRGc63eafm6Rtglqrg==
X-Received: by 2002:a1c:e302:: with SMTP id a2mr2364418wmh.96.1588315299701;
        Thu, 30 Apr 2020 23:41:39 -0700 (PDT)
Received: from ?IPv6:2001:16b8:48db:9b00:e80e:f5df:f780:7d57? ([2001:16b8:48db:9b00:e80e:f5df:f780:7d57])
        by smtp.gmail.com with ESMTPSA id u127sm2576769wme.8.2020.04.30.23.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 23:41:39 -0700 (PDT)
Subject: Re: [RFC PATCH V2 1/9] include/linux/pagemap.h: introduce
 attach/clear_page_private
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Yafang Shao <laoar.shao@gmail.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        devel@lists.orangefs.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roman Gushchin <guro@fb.com>,
        Andreas Dilger <adilger@dilger.ca>
References: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
 <20200430214450.10662-2-guoqing.jiang@cloud.ionos.com>
 <20200430221338.GY29705@bombadil.infradead.org>
 <20200501014229.GB23230@ZenIV.linux.org.uk>
 <20200501014954.GC23230@ZenIV.linux.org.uk>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <aacdc25b-4650-6251-acf5-5c2c8b77f292@cloud.ionos.com>
Date:   Fri, 1 May 2020 08:41:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501014954.GC23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/1/20 3:49 AM, Al Viro wrote:
> On Fri, May 01, 2020 at 02:42:29AM +0100, Al Viro wrote:
>> On Thu, Apr 30, 2020 at 03:13:38PM -0700, Matthew Wilcox wrote:
>>
>>>> +/**
>>>> + * clear_page_private - clear page's private field and PG_private.
>>>> + * @page: page to be cleared.
>>>> + *
>>>> + * The counterpart function of attach_page_private.
>>>> + * Return: private data of page or NULL if page doesn't have private data.
>>>> + */
>>> Seems to me that the opposite of "attach" is "detach", not "clear".
>> Or "remove", perhaps...
> Actually, "detach" is better - neither "clear" nor "remove" imply "... and give
> me what used to be attached there", as this thing is doing.

Ok, seems we have reached the agreement about the new name ;-), will 
follow the instruction.

Thanks & Regards,
Guoqing
