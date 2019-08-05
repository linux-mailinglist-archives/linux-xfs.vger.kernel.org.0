Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA9B826DA
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 23:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfHEV2w (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Aug 2019 17:28:52 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37539 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730516AbfHEV2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 17:28:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so40271887pfa.4
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 14:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N6otElHpgyEjGVoCaiPv8i7EM/fhujFlztleZHUQiOo=;
        b=ipWqF/HAH+6HlfjFTSBpvvJdX/JOHAUgEu9I865i1VytvifXLUltZ+GpjYVIbxQqUd
         Db/cdwVEo7qIcdiAyJYF8pv0nz7N8Xqxe9MSTs3zWth7p5SHAP1nXHmC18l7Ji/MY4D5
         jX9pzgC08OQyb1N3eZlo9r+soaDSNgEXFsIn/L3od6UJkSLUHM6y5fhU2OED1jQc+Q8d
         QP1V2SdYn6vlANbU5j4044rRgVjD6Gv+Hm1uuYp1dDVzHiUJLfWXWoPeW1dDBs98tD7x
         UucCVAm5567IJhdBfWHCujMtSsPM5j2j7UYUrZscu5JnmxC1xcoRLzk5emnpBWiEqOUJ
         N6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N6otElHpgyEjGVoCaiPv8i7EM/fhujFlztleZHUQiOo=;
        b=RY1J/bMvKx8JqUR/SkENUo1Mr64zFen4K0lN5S/ZmTmuiHBYZ35HmeAUnMdWbuzgkZ
         7ZIiE1BY596xSe0miuwnR/TgvHdJKGUa5kEsBVkGskK41zIvVfym7Q8/g7RyKpb34aao
         nLtegg7OcxMVDHSNz6G3az9qpLbbraEzC+G1hgMkFOwI5p2vaWAJ9BNUof5Na+bRQIdP
         B1PoBdSkinSEE8wi0v2MthC7+fR92qi91OMfDmOJHz/xO+kfnZ6e6PALxnnwYo2m0s7Y
         7EXymjZ1tZ86n/UD84jX2s3wICLHIkoECv2/JFpEZ3gD1NlsE5h++aT0P2DxNmJr4n4/
         i4hA==
X-Gm-Message-State: APjAAAW8B49gDtbQPXCNl441Bq6hhtZ1R8w07NGpucd7BsPCCv8yeGWj
        DliXfZE8ybLm62YyMWXtgrLOXQHOIc63dg==
X-Google-Smtp-Source: APXvYqzhBKyuLsOVHEc9c+i1pQSjZRDiztraq1AEHUUx1LXgn6ddJ44fS1ID4RKnjDCsFNAYtvEr8Q==
X-Received: by 2002:a17:90a:d14a:: with SMTP id t10mr20304779pjw.85.1565040530775;
        Mon, 05 Aug 2019 14:28:50 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:83a1:3cf5:36ed:899e:8d54? ([2605:e000:100e:83a1:3cf5:36ed:899e:8d54])
        by smtp.gmail.com with ESMTPSA id d2sm16985134pjs.21.2019.08.05.14.28.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 14:28:49 -0700 (PDT)
Subject: Re: Block device direct read EIO handling broken?
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20190805181524.GE7129@magnolia>
 <66bd785d-7598-5cc2-5e98-447fd128c153@kernel.dk>
 <36973a52-e876-fc09-7a63-2fc16b855f8d@kernel.dk>
 <BYAPR04MB5816246256B1333C048EB0A1E7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <474c560f-5de0-6082-67ac-f7c640d9b346@kernel.dk>
 <BYAPR04MB5816C3B24310C1E18F9E024CE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f3f98663-8f92-c933-c7c0-8db6635e6112@kernel.dk>
Date:   Mon, 5 Aug 2019 14:28:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816C3B24310C1E18F9E024CE7DA0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/5/19 2:27 PM, Damien Le Moal wrote:
> On 2019/08/06 6:26, Jens Axboe wrote:
>>> In any case, looking again at this code, it looks like there is a
>>> problem with dio->size being incremented early, even for fragments
>>> that get BLK_QC_T_EAGAIN, because dio->size is being used in
>>> blkdev_bio_end_io(). So an incorrect size can be reported to user
>>> space in that case on completion (e.g. large asynchronous no-wait dio
>>> that cannot be issued in one go).
>>>
>>> So maybe something like this ? (completely untested)
>>
>> I think that looks pretty good, I like not double accounting with
>> this_size and dio->size, and we retain the old style ordering for the
>> ret value.
> 
> Do you want a proper patch with real testing backup ? I can send that
> later today.

Yeah that'd be great, I like your approach better.

-- 
Jens Axboe

