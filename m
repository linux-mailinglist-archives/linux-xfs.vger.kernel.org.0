Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15CC2F4574
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jan 2021 08:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbhAMHpH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Jan 2021 02:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbhAMHpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 02:45:07 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CB6C061786
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 23:44:27 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 3so659261wmg.4
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 23:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/heJO8JuiwWynfejNELMn+jLslnfJcq2KDsfSuPxcbQ=;
        b=NlBz7GVjb4Q/1HDjQyOub+gmJxqQSKqZzMYL+oIcjfWmhVRv86zhY78pV2mUQnbeNE
         C6o8QTcUX5LXssfy0z+a3QnvkkVCq0goZjMG31/G+Fb/fEpbbKtaONOyXkID4KP/1EmN
         BoLKvrnZfEn+IZhtVloV3cYc1nzfSgC4FGCsvEu/jeFDp78J06XcY94XuRGkEqJp5fEE
         zEb4Cum1WFYXjtT3OAt3B1hKEXJfQ/251AUXSc+82KfcNIBAJB+Z8nlz7XcgkE2IcCcM
         QcY+yavRAYeO+fMqEsglH+I+w0KQtSkKNJZy5xzMjMs5IcDFkjGr7tUg4g13j9gdnC2c
         /HnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/heJO8JuiwWynfejNELMn+jLslnfJcq2KDsfSuPxcbQ=;
        b=FpWnfmnQbujyRzP4TPyFlSKK9pJyluT8+23nFrk6NiJL5vtVt2xmQO+Cy+iIwKwZSA
         yzU0kut42kwiuJfk2NXRNe3bYtL1b8bO2OT7nVEKbKyjG0beF0Oqb+kZ+bb7xq3vHdjk
         gTiV+i1r+qS9sIwkIEjs/ni/Z8Jbb+GVqRv5vst+z7N/S3GthUdwmI+ZtD2IiktaFyQG
         X8fBJOiJpLrtBggma9F/W1s02FWpnO5zjGE0T0GW02AWun/tAgNLFYLLTpQhKU/iW0RH
         0FUBeNG/iQr8NKGYNbYy9R90V1D7Nulv4+PyWaWvOrdCCgW6dVrH/2KzYlYAOq3PLqC9
         h8VQ==
X-Gm-Message-State: AOAM530FJIdpjukiYWXoxwklZgXwzjtZrIFREhVwlIp1M1arqNeArOC1
        KCNyoVDkv+EvkxFJxL05S8FxK9u5TJhU0g==
X-Google-Smtp-Source: ABdhPJx7MW2aMt8z2+SBIHQjiNmjoSXt1hhH/So7B4H/JbgwgN6T6eFxrkIFaEv5nlsFLYOBoXX31Q==
X-Received: by 2002:a1c:3d56:: with SMTP id k83mr666672wma.25.1610523865907;
        Tue, 12 Jan 2021 23:44:25 -0800 (PST)
Received: from tmp.scylladb.com (bzq-79-182-3-66.red.bezeqint.net. [79.182.3.66])
        by smtp.googlemail.com with ESMTPSA id r20sm1902245wrg.66.2021.01.12.23.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 23:44:24 -0800 (PST)
Subject: Re: fallocate(FALLOC_FL_ZERO_RANGE_BUT_REALLY) to avoid unwritten
 extents?
To:     Andres Freund <andres@anarazel.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-block@vger.kernel.org
References: <20201230062819.yinrrp6uwfegsqo3@alap3.anarazel.de>
 <20210104181958.GE6908@magnolia>
 <20210104191058.sryksqjnjjnn5raa@alap3.anarazel.de>
 <f6f75f11-5d5b-ae63-d584-4b6f09ff401e@scylladb.com>
 <20210112181600.GA1228497@infradead.org>
 <C8811877-48A9-4199-9F28-20F5B071AE36@dilger.ca>
 <20210112184339.GA1238746@infradead.org>
 <1C33DEE4-8BE9-4BF3-A589-E11532382B36@dilger.ca>
 <20210112211445.GC1164248@magnolia>
 <20210112213633.fb4tjlgvo6tznfr4@alap3.anarazel.de>
From:   Avi Kivity <avi@scylladb.com>
Message-ID: <6d982635-d978-e044-4cca-c140401eb0d3@scylladb.com>
Date:   Wed, 13 Jan 2021 09:44:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112213633.fb4tjlgvo6tznfr4@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/12/21 11:36 PM, Andres Freund wrote:
> Hi,
>
> On 2021-01-12 13:14:45 -0800, Darrick J. Wong wrote:
>> ALLOCSP64 can only allocate pre-zeroed blocks as part of extending EOF,
>> whereas a new FZERO flag means that we can pre-zero an arbitrary range
>> of bytes in a file.  I don't know if Avi or Andres' usecases demand that
>> kind of flexibilty but I know I'd rather go for the more powerful
>> interface.
> Postgres/I don't at the moment have a need to allocate "written" zeroed
> space anywhere but EOF. I can see some potential uses for more flexible
> pre-zeroing in the future though, but not very near term.
>

Same here.


I also agree that it's better not to have the kernel fall back 
internally on writing zeros, letting userspace do that. The assumption 
is that WRITE SAME will be O(1)-ish and so can bypass scheduling 
decisions, but if we need to write zeros, better let the application 
throttle the rate.


