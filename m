Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD60C1396E8
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Jan 2020 18:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgAMRAh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Jan 2020 12:00:37 -0500
Received: from mr011msb.fastweb.it ([85.18.95.108]:37396 "EHLO
        mr011msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgAMRAh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 12:00:37 -0500
Received-SPF: pass (mr011msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr011msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrvdejtddgleefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhfhokffffgggjggtgfesthejredttdefjeenucfhrhhomhepifhiohhnrghtrghnucffrghnthhiuceoghdruggrnhhtihesrghsshihohhmrgdrihhtqeenucffohhmrghinheprghsshihohhmrgdrihhtnecukfhppeelfedrieefrdehhedrheejnecurfgrrhgrmhephhgvlhhopegtvghrvghsrdgrshhshihomhgrrdhithdpihhnvghtpeelfedrieefrdehhedrheejpdhmrghilhhfrhhomhepoehgrdgurghnthhisegrshhshihomhgrrdhithequceuqfffjgepkeeukffvoffkoffgpdhrtghpthhtohepoegurghrrhhitghkrdifohhnghesohhrrggtlhgvrdgtohhmqecuqfftvefrvfeprhhftgekvddvnegurghrrhhitghkrdifohhnghesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepoehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgqecuqfftvefrvfeprhhftgekvddvnehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr011msb.fastweb.it (5.8.208)
        id 5E19B4DB0026C4D9; Mon, 13 Jan 2020 18:00:15 +0100
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id 4BD1726327A;
        Mon, 13 Jan 2020 18:00:15 +0100 (CET)
Subject: Re: XFS reflink vs ThinLVM
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org,
        "'g.danti@assyoma.it'" <g.danti@assyoma.it>
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
 <20200113114356.midcgudwxpze3xfw@orion>
 <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
 <20200113165341.GE8247@magnolia>
From:   Gionatan Danti <g.danti@assyoma.it>
Organization: Assyoma s.r.l.
Message-ID: <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
Date:   Mon, 13 Jan 2020 18:00:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200113165341.GE8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13/01/20 17:53, Darrick J. Wong wrote:
> mkfs.xfs -d extszinherit=NNN is what you want here.

Hi Darrik, thank you, I missed that option.

> Right.

Ok

> xfs_bmap -c, but only if you have xfs debugging enabled.

[root@neutron xfs]# xfs_bmap -c test.img
/usr/sbin/xfs_bmap: illegal option -- c
Usage: xfs_bmap [-adelpvV] [-n nx] file...

Maybe my xfs_bmap version is too old:

> If you happen to have rmap enabled, you can use the xfs_io fsmap command
> to look for 'cow reservation' blocks, since that 124k is (according to
> ondisk metadata, anyway) owned by the refcount btree until it gets
> remapped into the file on writeback.

I see. By default, on RHEL at least, rmapbt is disabled. As a side note, 
do you suggest enabling it when creating a new fs?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
