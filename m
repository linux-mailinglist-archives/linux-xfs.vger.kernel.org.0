Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F55BD92
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 16:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfGAOFG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 10:05:06 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41231 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbfGAOFG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 10:05:06 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so29035869ioc.8
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2019 07:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9IU9Vum1iEYXNFUQZJjTlbhqVVSUgpHJpWnEL+ydahk=;
        b=zJSjcaNlk9MyLQy21nWTiY8jfylj+b2oHUfdD3gsHMqdUrDnNS8H0Qjd/1RxTRCofj
         bU67WSUYf88+pyHStt0iUmfaB3OqQT2Do1CkVIWW3uLxLDV3gg3qy0aIFH+nrKS4j7Ln
         4hPzI0zEjU0cUx0RhPZ4Zu/f9Ztj/uE9vkxOdwK6eFA5B10PtX65IvI2ztmg5577svSn
         U9OXsWI+xAT5Dqe+xDWL/U52PzsOaADKukHP8yAtGuwSmL3QkQXpHOr9B0DaTweEYh6e
         3WS6WnIVPs4vc4pDx9QiPZvWgcH7asKyLptIE45o6RnSx4nK1ZTEQUJ1rb7U6PYd2Qdt
         NIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9IU9Vum1iEYXNFUQZJjTlbhqVVSUgpHJpWnEL+ydahk=;
        b=jO/2vYcBpboU8d1nhgt5mfbpd1GVy56+W4G8nGY9X11qcqsZfyWW+sEzgS4Q/JgXkx
         D2WAgoscYDjOqVNElZAqBhoZ6BUocbFrmlXSYqgMVGjF5PrD1FENcGtY78JE5skpWRgu
         P+b5AmKEHaM+LxjH24wn9VM5sSH1pT0Nig7/JC2XioleIjrTGcUQnN5egjf0EWHwITtt
         gQibb+DDZ41yNX5GZKpfyz3F/9YLuqZju4k1c/oDkdutHYA3FdsWeY9LHXmA7R8Wmdof
         piqgWDyyTgg7o6S6Wg+Iqi3ArCpIA9NpizzIyQoUI5OsFSuZjmVgAzjV294RzBP+GsyM
         XKLw==
X-Gm-Message-State: APjAAAVm6gNXC96qGpyz/9AdhUbr/oBfF4T1JxpKZB4v+f4rdlOY2o4J
        qDC9MmA11mzJtreM9acNQBdXbg==
X-Google-Smtp-Source: APXvYqzhrHY+sRdQ6KZLe3VL0lPbv09Q/COiAF3X6IakXifjdtvvYSO02UJsciHFjbggEaoQ8waVoQ==
X-Received: by 2002:a6b:b843:: with SMTP id i64mr730492iof.81.1561989905288;
        Mon, 01 Jul 2019 07:05:05 -0700 (PDT)
Received: from [192.168.1.158] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w23sm9787246iod.12.2019.07.01.07.05.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 07:05:03 -0700 (PDT)
Subject: Re: [PATCH V2] block: fix .bi_size overflow
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20190701071446.22028-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
Date:   Mon, 1 Jul 2019 08:05:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190701071446.22028-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/1/19 1:14 AM, Ming Lei wrote:
> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
> bytes.
> 
> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
> include very limited pages, and usually at most 256, so the fs bio
> size won't be bigger than 1M bytes most of times.
> 
> Since we support multi-page bvec, in theory one fs bio really can
> be added > 1M pages, especially in case of hugepage, or big writeback
> with too many dirty pages. Then there is chance in which .bi_size
> is overflowed.
> 
> Fixes this issue by using bio_full() to check if the added segment may
> overflow .bi_size.

Any objections to queuing this up for 5.3? It's not a new regression
this series.

-- 
Jens Axboe

