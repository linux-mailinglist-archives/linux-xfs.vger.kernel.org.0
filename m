Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3460C4E34D
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 11:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfFUJUC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 05:20:02 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41972 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfFUJUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 05:20:02 -0400
Received: by mail-pl1-f194.google.com with SMTP id m7so2691590pls.8;
        Fri, 21 Jun 2019 02:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+QnuYdH4J1LxacDJx/SJ4P2M/9IIlcIznj/d1iccsYY=;
        b=R3Qdw9WJIHCTfe/P00WShN9TZbpXng8zKpaSeuo8tHRgpIKb7D7ovk3EbT77NNwRbW
         iz4LIx+1pfq9h70Gnq5S79mKhfGZeZTg6/WCUEAuCJt8JAz6DQg0e4d+Q9/Ki0wDTpQi
         Naam6IFtWpUD1V0mtYicBXEvEYYnh8SVuk0K7ZsfBfFbgGcw4VW5/pyPb8RF44h2il2X
         mEAw/NL7fuE+OCpK0859e6WUyKWz46KfRZwR2HZKhr9zjv4EALaLnKOW9HsH+FX2ICbl
         p/0KcnHkAgi8kx+JTBT2w0MVT9vD/4wpoifBa2Xk7etPBYwj+O3mDtMEMd96sHflU8Ux
         it4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+QnuYdH4J1LxacDJx/SJ4P2M/9IIlcIznj/d1iccsYY=;
        b=MdlXWg+76O9mQ40atuuCy4Mlvz+D04u5X3wK8sUJBU5ivkk4aqd/JFlLU7qZnRITwv
         ReFJ0moPWNCopqmin/KwjUIrQVk6wHTWHPRkKaRkdl/tFUenTzwjJxqdoXqDAOu6S9yb
         LO70yYeP0lfWzgP4F/44ocr/dsaH3wkfup/v5hnAQwMbiB016iizkr7hOs+NAB8kl8af
         sTJ0eNA5Zvm5jULiFCQh9UUrXqhA3xiNaaDYSaAyTJPl0HV/dsiU4JIUGCrvP6MHcu23
         UyAPGij+PP//tvpXJsYYDoxzsX48CrF+S7dYSAdyzleLGwVTRl9skHNSKdZrTgWGWXOu
         Nqag==
X-Gm-Message-State: APjAAAVD4lGMVy803Tdq0y6Xtykmso2Vj8kRxTkqYOvkzYC2q4smeJjo
        JHDikHHr055+vsHIcnRjMwQ=
X-Google-Smtp-Source: APXvYqxJdS6ilpBysYijJjIWVAryXVB1uNp5Xq5uJnFiLNbNZp0Wc0mOgtScyrRiRjb2h+Te6Y80Jw==
X-Received: by 2002:a17:902:830b:: with SMTP id bd11mr78073099plb.202.1561108801590;
        Fri, 21 Jun 2019 02:20:01 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id f11sm2222450pga.59.2019.06.21.02.20.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 02:20:01 -0700 (PDT)
Date:   Fri, 21 Jun 2019 17:19:55 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs/119: fix MKFS_OPTIONS exporting
Message-ID: <20190621091955.GJ15846@desktop>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089204777.345809.18314859473454869520.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156089204777.345809.18314859473454869520.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 02:07:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This test originally exported its own MKFS_OPTIONS to force the tested
> filesystem config to the mkfs defaults + test-specific log size options.
> This overrides whatever the test runner might have set in MKFS_OPTIONS.
> 
> In commit 2fd273886b525 ("xfs: refactor minimum log size formatting
> code") we fail to export our test-specific MKFS_OPTIONS before
> calculating the minimum log size, which leads to the wrong min log size
> being calculated once we fixed the helper to be smarter about mkfs options.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'll apply this one along with patch 2/4, once that one is updated.

Thanks,
Eryu

> ---
>  tests/xfs/119 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/119 b/tests/xfs/119
> index 8825a5c3..f245a0a6 100755
> --- a/tests/xfs/119
> +++ b/tests/xfs/119
> @@ -38,7 +38,8 @@ _require_scratch
>  # this may hang
>  sync
>  
> -logblks=$(_scratch_find_xfs_min_logblocks -l version=2,su=64k)
> +export MKFS_OPTIONS="-l version=2,su=64k"
> +logblks=$(_scratch_find_xfs_min_logblocks)
>  export MKFS_OPTIONS="-l version=2,size=${logblks}b,su=64k"
>  export MOUNT_OPTIONS="-o logbsize=64k"
>  _scratch_mkfs_xfs >/dev/null
> 
