Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230DB9DD73
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2019 08:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfH0GN2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Aug 2019 02:13:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42205 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfH0GN2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 02:13:28 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i2UjI-0002zO-LZ; Tue, 27 Aug 2019 08:13:20 +0200
Date:   Tue, 27 Aug 2019 08:13:19 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
cc:     Eryu Guan <guaneryu@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH v2] generic: test for failure to unlock inode after chgrp
 fails with EDQUOT
In-Reply-To: <20190827041816.GB1037528@magnolia>
Message-ID: <alpine.DEB.2.21.1908270811030.1939@nanos.tec.linutronix.de>
References: <20190827041816.GB1037528@magnolia>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 26 Aug 2019, Darrick J. Wong wrote:
> +++ b/tests/generic/719
> @@ -0,0 +1,59 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-newer

Please run scripts/spdxcheck.py on that file and consult the licensing
documentation.

Thanks,

	tglx
