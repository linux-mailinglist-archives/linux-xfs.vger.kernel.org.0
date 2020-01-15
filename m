Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2BEC13BF22
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jan 2020 13:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbgAOMEG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Jan 2020 07:04:06 -0500
Received: from mr012msb.fastweb.it ([85.18.95.109]:46000 "EHLO
        mr012msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgAOMEG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 07:04:06 -0500
Received-SPF: pass (mr012msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr012msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdeftdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhtefuvfghgfeupdcuqfgfvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffhvfhfohfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeouggrrhhrihgtkhdrfihonhhgsehorhgrtghlvgdrtghomhequcfqtfevrffvpehrfhgtkedvvdenuggrrhhrihgtkhdrfihonhhgsehorhgrtghlvgdrtghomhdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr012msb.fastweb.it (5.8.208)
        id 5E19B4C2004A415E; Wed, 15 Jan 2020 12:37:52 +0100
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id 79D8126646E;
        Wed, 15 Jan 2020 12:37:52 +0100 (CET)
Subject: Re: XFS reflink vs ThinLVM
From:   Gionatan Danti <g.danti@assyoma.it>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
 <20200113114356.midcgudwxpze3xfw@orion>
 <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
 <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
 <20200113180914.GI8247@magnolia>
 <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
Organization: Assyoma s.r.l.
Message-ID: <9d8e8614-9ae1-30ee-f2b4-1e45b90b27f8@assyoma.it>
Date:   Wed, 15 Jan 2020 12:37:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 14/01/20 09:45, Gionatan Danti wrote:
> On 13/01/20 19:09, Darrick J. Wong wrote:
>> xfs_io -c 'bmap -c -e -l -p -v <whatever>' test.img
> 
> Ok, good to know. Thanks.

Hi all, I have an additional question about extszinherit/extsize.

If I understand it correctly, by default it is 0: any non-EOF writes on 
a sparse file will allocate how much space it needs. If these writes are 
random and small enough (ie: 4k random writes), a subsequent sequential 
read of the same file will have much lower performance (because 
sequential IO are transformed in random accesses by the logical/physical 
block remapping).

Setting a 128K extszinherit (for the entire filesystem) or extsize (for 
a file/dir) will markedly improve the situation, as much bigger 
contiguous LBA regions can be read for each IO (note: I know SSD and 
NVME disks are much less impacted by fragmentation, but I am mainly 
speaking about HDD here).

So, my question: there is anything wrong and/or I should be aware when 
using a 128K extsize, so setting it the same as cowextsize? The only 
possible drawback I can think is a coarse granularity when allocating 
from the sparse file (ie: a 4k write will allocate the full 128k extent).

Am I missing something?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
