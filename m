Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21E55BDFC
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 16:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbfGAOUQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 10:20:16 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42940 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729437AbfGAOUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 10:20:16 -0400
Received: by mail-io1-f67.google.com with SMTP id u19so20654676ior.9
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2019 07:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gY2k8VIohQ3ovxqeqDMTJ6ugNx1qArSvmGqVd7Pptw4=;
        b=NDZmZNXBYjxdVurBwDt9g5WKl0ag//3VUaKT3FtinSCEP5Y94YcX/BINZsZ/Mu3tzi
         ZSBAxmh2aZkjJfDljLD3Ov9tHbhxX0xpfe8LghnrwYd5yACyUn1fjcssgoswM+UfRz2w
         pNzJjDgqUeXhutm+dYFFury6s38MOslCTgsNHRkUvW9258TEKv1i1fb+G/k3mzJjwC9w
         lg4fnlg3a5ETWFvz3FqAiQdUF9RYhlcCPxocYHjc2Tcz5ZtY/6JsRhUSxVVHljPak9lO
         JJABb2gemEOKBbob3AXWpoMzr5XSfC+HTj2lv5NFKWqaaDa6fe/t4eHyjrI/j8ywZAnG
         68Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gY2k8VIohQ3ovxqeqDMTJ6ugNx1qArSvmGqVd7Pptw4=;
        b=alnuHrv8eNyYJrdLHpSgHNdnLtL0ovlO+5FqApmvAbp/vjkPrxM3Dxbk4mEeZfrJoM
         1BIFDzRH3o7ElqxVEszVIwS3ukTAxRP5svoZrFEG65sFpX8eu64Sss4sXxGFvusHRIXr
         zYP08sO4h5rnq0lAYH8I83wImbWqFJG6C+RQUbVTTHTpF076JeKt8YgCyQpZmFDCrIii
         3EVd5ui1E9hRETg7wfFnb+B4bf/gzftaGPwMTuPY6R4SaHrK0JfzZoIqY8aa3meN7vLy
         odTq7E05t8mCRL+g2vbXF905P2sMk2qgnvnOOobHum3WSXYaKOBa9iq6hwUuINr0QgxW
         v8aQ==
X-Gm-Message-State: APjAAAWTEQZWC90iH5phEQEpp4m5agO2J5YcEQD+n+8oDWvHgoYQ1Rri
        b8pp2+Cl0JqDxcmx++22xpTmmw==
X-Google-Smtp-Source: APXvYqwSj4J+56s9p49bTmZyPQaGM1CAyE3LWgyIlQfGltnN7r1QlI1141Kni7B/XmjMjAjm5WgT7w==
X-Received: by 2002:a02:cd83:: with SMTP id l3mr26548737jap.66.1561990815765;
        Mon, 01 Jul 2019 07:20:15 -0700 (PDT)
Received: from [192.168.1.158] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x13sm9765649ioj.18.2019.07.01.07.20.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 07:20:14 -0700 (PDT)
Subject: Re: [PATCH V2] block: fix .bi_size overflow
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20190701071446.22028-1-ming.lei@redhat.com>
 <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
 <bd45842a-e0fd-28a7-ac79-96f7cb9b66e4@kernel.dk>
Message-ID: <8b8dc953-e663-e3d8-b991-9d8dba9270be@kernel.dk>
Date:   Mon, 1 Jul 2019 08:20:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <bd45842a-e0fd-28a7-ac79-96f7cb9b66e4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/1/19 8:14 AM, Jens Axboe wrote:
> On 7/1/19 8:05 AM, Jens Axboe wrote:
>> On 7/1/19 1:14 AM, Ming Lei wrote:
>>> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
>>> bytes.
>>>
>>> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
>>> include very limited pages, and usually at most 256, so the fs bio
>>> size won't be bigger than 1M bytes most of times.
>>>
>>> Since we support multi-page bvec, in theory one fs bio really can
>>> be added > 1M pages, especially in case of hugepage, or big writeback
>>> with too many dirty pages. Then there is chance in which .bi_size
>>> is overflowed.
>>>
>>> Fixes this issue by using bio_full() to check if the added segment may
>>> overflow .bi_size.
>>
>> Any objections to queuing this up for 5.3? It's not a new regression
>> this series.
> 
> I took a closer look, and applied for 5.3 and removed the stable tag.
> We'll need to apply your patch for stable, and I added an adapted
> one for 5.3. I don't want a huge merge hassle because of this.

OK, so we still get conflicts with that, due to both the same page
merge fix, and Christophs 5.3 changes.

I ended up pulling in 5.2-rc6 in for-5.3/block, which resolves at
least most of it, and kept the stable tag since now it's possible
to backport without too much trouble.

-- 
Jens Axboe

