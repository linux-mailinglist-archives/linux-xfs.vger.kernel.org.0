Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C32139005
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Jan 2020 12:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgAMLZa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Jan 2020 06:25:30 -0500
Received: from mr011msb.fastweb.it ([85.18.95.108]:42099 "EHLO
        mr011msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgAMLZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 06:25:30 -0500
Received-SPF: pass (mr011msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr011msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrvdejtddgvdekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvfhfhohfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr011msb.fastweb.it (5.8.208)
        id 5E19B4DB00213CED for linux-xfs@vger.kernel.org; Mon, 13 Jan 2020 12:25:26 +0100
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id 225A7264086;
        Mon, 13 Jan 2020 12:25:26 +0100 (CET)
Subject: Re: XFS reflink vs ThinLVM
To:     linux-xfs@vger.kernel.org
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <20200113111025.liaargk3sf4wbngr@orion>
Cc:     "'g.danti@assyoma.it'" <g.danti@assyoma.it>
From:   Gionatan Danti <g.danti@assyoma.it>
Organization: Assyoma s.r.l.
Message-ID: <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
Date:   Mon, 13 Jan 2020 12:25:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200113111025.liaargk3sf4wbngr@orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13/01/20 12:10, Carlos Maiolino wrote:
> First of all, I think there is no 'right' answer, but instead, use what best fit
> you and your environment. As you mentioned, there are PROs and CONS for each
> different solution.
> 
> I use XFS reflink to CoW my Virtual Machines I use for testing. As I know many
> others do the same, and it works very well, but as you said. It is file-based
> disk images, opposed to volume-based disk images, used by DM and LVM.man.
> 
> About your concern regarding fragmentation... The granularity is not really 4k,
> as it really depends on the extent sizes. Well, yes, the fundamental granularity
> is block size, but we basically never allocate a single block...
> 
> Also, you can control it by using extent size hints, which will help reduce the
> fragmentation you are concerned about.
> Check 'extsize' and 'cowextsize' arguments for mkfs.xfs and xfs_io.

Hi Carlos, thank you for pointing me to the "cowextsize" option. From 
what I can read, it default to 32 blocks x 4 KB = 128 KB, which is a 
very reasonable granularity for CoW space/fragmentation tradeoff.

On the other hand, "extsize" seems to apply only to realtime filesystem 
section (which I don't plan to use), right?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
