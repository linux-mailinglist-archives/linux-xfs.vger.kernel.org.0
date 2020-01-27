Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B1514A418
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Jan 2020 13:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgA0MtW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Jan 2020 07:49:22 -0500
Received: from mout.web.de ([212.227.17.12]:38639 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgA0MtW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Jan 2020 07:49:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1580129347;
        bh=8g0N+5vkbrFGE4HcBA9m8HyPWC69TkpnzXDwc8vS7m0=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=a/tS/vkUmnveU/ULaj1hoYayAujN+oVlvv8EwPUsAb+xE3KZsPsWEFNEAJNme+qiJ
         XECRvzD72EfTfSdhdoe7JQIL21Ink7RJEJWFTI0eCP1a+Lbw1riIal83cDni59DRnA
         +xb/EfHd2m/O2bHQnYIvRYDgKWYNNi+mbH8wFO00=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.115.58]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lheqz-1jR10M1KYj-00mugG; Mon, 27
 Jan 2020 13:49:07 +0100
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <jth@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v9 1/2] fs: New zonefs file system
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <3021e46f-d30b-f6c5-b1fc-81206a7d034b@web.de>
Date:   Mon, 27 Jan 2020 13:49:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Xq7UEX3MCWoL97fvw/kbgyMqO0Cu88G4a1vKTFqLdIQDHQgWBTH
 6MWpr+4iE3GCG6weqG9bgpMXx3lyWx2TmbdwIbckdDqf0yY4pyUr11bGL9NuNuQJ1PqaJ+a
 pQ3/nGL3I0ZXS1tNlrMXi4ICCE9LnoL1z1VTBQ3XKR9gXybQAKFBElXLxEqv356ET0Dzzou
 ENxAk1BnpvNI2THz5L8iQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xGs9W2dYyCQ=:07Tudto3Rvo0ZaiAjLmjrV
 i1TmdkghiFPOs6Tmssju6yVEnEO4MQO8vRP64+H/0iNK8q18roCmxvg76gwaHcUqGdJqwLWyI
 VOXvf9Tv1K/X+4Ot+SWRZEZI8Fzrwvv9PxldoHuezj/XwJJpozvybMAGkx5lRLhWw7nIVsyPb
 sivEQdQNmxdgVhfRPvpslxfv74xb2/cFeovaJ54kQ5LV487Xy30ZG7AoZt3Lciz8PoHvgP4v6
 tsf4hmH08+KE+oNZsE5yXd5TtglifB3yqLTLszXhTovsHCKHZjbHuaOmMF7Gh/xKPghiw2dk/
 ifWANmuT/8LtEwmMy0EGNweYUVYbqQvPcPbQbEb1QjLPPJ1Uq7o5YmBBQW6t4HCe6JPOlcVTo
 24S1GCeiocXXZh+O5qOwhojQmMDO0pdBULFcJ1kK5mweCwrhy3BeUgrvkUWV81n8d4pUF5e6Y
 eRGAPdYxCsyJw+buqjw3LLudhvVHzf9T068sp9lAN8ZYtuyQKQ8yMew2NlcxCeDAFtsA1HKqi
 bmq8xKzWfWyFiV6ofkljh1qwm4yUgfYD/jZxsi6PjgnbWl+KojQ5uzfFLHCu+z0fLWeqvDe2l
 KvwCSot357WlI8Pl6MprxqbZw1JlrVsUoPVB1pyZxomU1YSJQy09JBC9ZENdBarLNdLdUuisc
 kYzX6cio5X7gftVVetupF0SuJaGvgU6Wmz/iQx/F9gNKVWP8Xtt+7uLqHSaynuN6FcSvAAc+8
 SKE6u/mtL9sM58hx/JO5kPOHAh6KD1kNOqnLxm/CHDQxnR1+fXUoL3eVHnwXz0D09YetkLE9j
 iWrRmpMEMSEmuJ5KaMxoF6C7+LyCrlDB7/M7VoJ5MnUJcJdupNrWEELRqWzqntQX5dOKXtpH2
 XoLdjHwnentrtyrZLfTNQKo9ZhygJ6OL4Vw1YWk2e7m+WJLoazhuHP/Hdk5X5PHNbQ41i/yIy
 UHraxCK6vHywegSpyzfuYK1cCiPqpxv+bDSAJ9zQnm2CTC8UbPmvDwF0D/hCCkwo+Ex8bPDdY
 qrLSEb9DUF4530vTQR0FpZ8LTjEPkuBYvFyWmszKe9h7pSxAuGvlLx6vW69GJ+guwW3y208Q2
 4xoG8qeobCnKvuLpa5DjOqcTvpAJ+fRqDPoD6mUNmqMcprwJC5EsJx+J7leVwYB6loSadg0Hp
 /ru0QzoEJgaVUdoBu8quZHzGnHEt72NoB5LAvp2ved5IChZX+I83nYtTeDS7PSm9Ar5qFghVY
 aMiypjuAuA8G/qiMH
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

=E2=80=A6
> +++ b/fs/zonefs/super.c
=E2=80=A6
> +static char *zgroups_name[ZONEFS_ZTYPE_MAX] =3D { "cnv", "seq" };

Would you like to keep this array as mutable?
How do you think about to mark such data structures as =E2=80=9Cconst=E2=
=80=9D?

Regards,
Markus
