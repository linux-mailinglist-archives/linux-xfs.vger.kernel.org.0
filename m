Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BEC395A3
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbfFGTaW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:30:22 -0400
Received: from ms.lwn.net ([45.79.88.28]:58516 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfFGTaW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 15:30:22 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 2A6D82CD;
        Fri,  7 Jun 2019 19:30:22 +0000 (UTC)
Date:   Fri, 7 Jun 2019 13:30:21 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Documentation: xfs: Fix typo
Message-ID: <20190607133021.3a537e3a@lwn.net>
In-Reply-To: <20190607183410.GF1871505@magnolia>
References: <20190509030549.2253-1-ruansy.fnst@cn.fujitsu.com>
        <20190607114415.32cb32dd@lwn.net>
        <20190607183410.GF1871505@magnolia>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 7 Jun 2019 11:34:10 -0700
"Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> I doubt the value of maintaining duplicate copies of this document in
> the kernel and the xfs documentation repo, and since the xfs docs and
> kernel licences aren't compatible maybe we should withdraw one...

Um .... the in-kernel docs say nothing about an incompatible license.  I
see only a GPL license at the repo you pointed to as well.  Is there
something I don't know going on here?  If the licenses aren't compatible
then those files shouldn't be there.

Thanks,

jon
