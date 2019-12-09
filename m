Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E97F116F8B
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Dec 2019 15:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfLIOuP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Dec 2019 09:50:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25581 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726354AbfLIOuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Dec 2019 09:50:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575903013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmXv5r+jYXphY7BscO2smGv5aBXrs+fMMrRQn1IS66s=;
        b=KZYSuTFfvO1SUMBac3WKVs3MjAQImVa0KmDCtycsOE/uTgjW/t9I5YrMVHptquZwzQWCwF
        8cAkU0Pyb+fmYIlJL4xSNg/ahgWa4ulXmB/nFvzL45b8EtSBaY855YA6OPY9/IvdeATK52
        8kvx5jbOijOd8PLjuPDsA3RgiLXJfho=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-JfcA_XDaNWW6qJqwF3QTWA-1; Mon, 09 Dec 2019 09:49:10 -0500
Received: by mail-wm1-f69.google.com with SMTP id l11so23427wmi.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Dec 2019 06:49:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LTG1mZGmZ9hcbwqZAQIUO+xcTEzvZOPY6N77kDf6jfs=;
        b=i2ET7bUp5AQA25ZWRRI9zVcO+rQ2C89nj5iiULidyO0F5X4DFz1eamoBCkRuimZNi5
         DttKfXVQfRDXlbQ1KvDgvxYBFDQP5/4lVl9vyDuUjmTipq25aJ8dJfgFVBe5N2QnWqOw
         XRHLHxiIX2zrILhHKpBETE42FozC7QhRGe80hzfDPs1J1KoiH883Mh1GtW1H4wvhBIhQ
         TBOA49Y90lSWm3Iw0CaqQEp58x0PYhew3aqmrX6lZrcNVBaSfVc23E3qFO7IOwRiTmoc
         xdWbfFxvpAlCQjp47tSEq3SiFWSL4OUADM1++IT9w4YXbJF4tAd4ppNyQ0QTigD5jMp9
         oB5g==
X-Gm-Message-State: APjAAAUNgtbfFf9Fhk7Bw9HEKyAXLSBFLm929h01MKWP+G4ilvH8SRKt
        5pHGQCGwXl3A4iwZCPy7bJ5UWU92Hafn3vAxpTKhXKoU/EwihIClwYyhXUOrW7OrTtgA90+0Lsy
        r1KPOxCyqPnACbgRJfLwm
X-Received: by 2002:adf:f108:: with SMTP id r8mr2640091wro.390.1575902948959;
        Mon, 09 Dec 2019 06:49:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqzeyuo2wJ8z5YlI5WtkiEPJHJQh87qKQlY3/8QtSaJHx1DoZzLAqxIrGtET/Y+H06nEwDhd7A==
X-Received: by 2002:adf:f108:: with SMTP id r8mr2640058wro.390.1575902948744;
        Mon, 09 Dec 2019 06:49:08 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id k4sm14506803wmk.26.2019.12.09.06.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 06:49:08 -0800 (PST)
Date:   Mon, 9 Dec 2019 15:49:06 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix Sphinx documentation warning
Message-ID: <20191209144906.u3hllhe5ekkqsvva@orion>
Mail-Followup-To: Randy Dunlap <rdunlap@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <bd3c7d7e-2859-06b0-a209-7d19f7c2e79f@infradead.org>
MIME-Version: 1.0
In-Reply-To: <bd3c7d7e-2859-06b0-a209-7d19f7c2e79f@infradead.org>
X-MC-Unique: JfcA_XDaNWW6qJqwF3QTWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 08, 2019 at 08:14:36PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Fix Sphinx documentation format warning by not indenting so much.
>=20
> Documentation/admin-guide/xfs.rst:257: WARNING: Block quote ends without =
a blank line; unexpected unindent.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> ---
>  Documentation/admin-guide/xfs.rst |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>=20
> --- linux-next-20191209.orig/Documentation/admin-guide/xfs.rst
> +++ linux-next-20191209/Documentation/admin-guide/xfs.rst
> @@ -253,7 +253,7 @@ The following sysctls are available for
>  =09pool.
> =20
>    fs.xfs.speculative_prealloc_lifetime
> -=09=09(Units: seconds   Min: 1  Default: 300  Max: 86400)
> +=09(Units: seconds   Min: 1  Default: 300  Max: 86400)
>  =09The interval at which the background scanning for inodes
>  =09with unused speculative preallocation runs. The scan
>  =09removes unused preallocation from clean inodes and releases
>=20

--=20
Carlos

