Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6832C58CC8D
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Aug 2022 19:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiHHRNN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Aug 2022 13:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiHHRNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Aug 2022 13:13:12 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8914E9FDD
        for <linux-xfs@vger.kernel.org>; Mon,  8 Aug 2022 10:13:11 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id d1so6857170qvs.0
        for <linux-xfs@vger.kernel.org>; Mon, 08 Aug 2022 10:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=VaHisQQWabFQj/Gcuzaw1a4FNljkcsjqnrmBjnOQNgQ=;
        b=kTNQ4MuWRVbB4ghQgXnbm9yMepMsE63zZX8lYlDLbVebVbwBaf/cVs8FaUZZwaeCRS
         PS/jUQMR3c1H9QjL2Du5VUJZoWVCBRSZKo1OPgOw1oNK3BSKjanMroHi7AzpjzXB05E4
         +wGXhuPersKgqETJt8OnezCSMzP5svfJdIV5Iw+xamkVELfOoHf0k6NJ8I4isTxDaUas
         XRQO3G51djwvqRJ22+4ad2mFesTPuwuwbEZYy09mRDHjsLRSMF29HeeAgxNeuol00RWH
         YCz2JtXuCwc/VsUIwWyYz5OCX1KpiuGQZK4iIoYqYcFHWP+6yxVg5aK9AzsMfSQ2xClI
         UCFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VaHisQQWabFQj/Gcuzaw1a4FNljkcsjqnrmBjnOQNgQ=;
        b=TfXOkFGVmcTU8bXppYwqSNZAEiuDbR4IKX53MGANtfrD7Ee3ep5l4VEAYvpAbYbAQ9
         prTQiuIEhq+HMUMwCh19tiLKFIQnFbQdSzjKl5QmasoDXSX0dDcEkQKHTW7a0SSaSyM2
         OCLRrqF7Cl/3n09cKsd6bG2ZEByuqdi2v84l9HPaY5mi/7jGslwRs4svxMRJfEUw/Z44
         WagPtSGOTkHUfTe9YSaF5n/GdrItoTer4UjaEWTOB3hoGK6hEi7NHtYyecvrosryBH9+
         Ui4rd6XXo/NXmk+E/qDkbN2Aw8eB+O6ei0MjgsyppaNZe8A4gpM9zoVqQQJ6P1rtlpE0
         QNcQ==
X-Gm-Message-State: ACgBeo2HTvgoDHCdyQjuatfYAAEu0UKXMSRd7NpZUvzwjliIxkJjALoy
        YE3fVs7fGZm7d/Duwqr+1VE=
X-Google-Smtp-Source: AA6agR4z7V3R8Nlm3AtH+39UzHTFxJ5jJt9H9A/9EoeRYhcOmFPWfeF0lTLmP7mzSkJdgQcOATbo5Q==
X-Received: by 2002:a05:6214:2386:b0:47b:5674:8739 with SMTP id fw6-20020a056214238600b0047b56748739mr3042220qvb.58.1659978790577;
        Mon, 08 Aug 2022 10:13:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o1-20020a05620a2a0100b006b942ae928bsm4351750qkp.71.2022.08.08.10.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 10:13:09 -0700 (PDT)
Message-ID: <14b36a0e-b567-e854-8791-0aed7af0567a@gmail.com>
Date:   Mon, 8 Aug 2022 10:13:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH] libxfs: stop overriding MAP_SYNC in publicly exported
 header files
Content-Language: en-US
To:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>
References: <WVSe_1J22WBxe1bXs0u1-LcME14brH0fGDu5RCt5eBvqFJCSvxxAEPHIObGT4iqkEoCCZv4vpOzGZSrLjg8gcQ==@protonmail.internalid>
 <YtiPgDT3imEyU2aF@magnolia> <20220721121128.yyxnvkn4opjdgcln@orion>
 <e6ee2759-8b55-61a9-ff6c-6410d185d35e@gmail.com> <YuQBarhgxff8Hih6@magnolia>
 <86691238-3de4-418d-5e94-981de043173e@sandeen.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <86691238-3de4-418d-5e94-981de043173e@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/4/22 19:11, Eric Sandeen wrote:
> 
> 
> On 7/29/22 10:48 AM, Darrick J. Wong wrote:
>>> Darrick, do you need to re-post, or can the maintainers pick up the patch directly?
>> I already did:
>> https://lore.kernel.org/linux-xfs/YtmB005kkkErb5uw@magnolia/
>>
>> (It's August, so I think the xfsprogs maintainer might be on vacation?
>> Either way, I'll make sure he's aware of it before the next release.)
>>
>> --D
>>
> 
> Yep I was, picking it up now. Thanks for the pointer Darrick.
> 
> -Eric

Eric, any chance this could be pushed to xfsprogs-dev.git so we can take 
the patch and submit it to buildroot, OpenWrt and other projects that 
depend upon that build fix?

Thanks!
-- 
Florian
