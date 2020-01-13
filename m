Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F011392C8
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Jan 2020 14:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgAMN6E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Jan 2020 08:58:04 -0500
Received: from verein.lst.de ([213.95.11.211]:41413 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbgAMN6D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Jan 2020 08:58:03 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 58A1068B20; Mon, 13 Jan 2020 14:58:00 +0100 (CET)
Date:   Mon, 13 Jan 2020 14:58:00 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Fix xfs_dir2_sf_entry_t size check
Message-ID: <20200113135800.GA8635@lst.de>
References: <20200109141459.21808-1-vincenzo.frascino@arm.com> <c43539f2-aa9b-4afa-985c-c438099732ff@sandeen.net> <1a540ee4-6597-c79e-1bce-6592cb2f3eae@arm.com> <20200109165048.GB8247@magnolia> <435bcb71-9126-b1f1-3803-4977754b36ff@arm.com> <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0eY6Vm5PNdzR8Min9MrwAqH8vnMZ3C+pxTQhiFVNPyWA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 02:55:15PM +0100, Arnd Bergmann wrote:
> With ARM OABI (which you get when EABI is disabled), structures are padded
> to multiples of 32 bits. See commits 8353a649f577 ("xfs: kill
> xfs_dir2_sf_off_t")
> and aa2dd0ad4d6d ("xfs: remove __arch_pack"). Those could be partially
> reverted to fix it again, but it doesn't seem worth it as there is
> probably nobody
> running XFS on OABI machines (actually with the build failure we can
> be fairly sure there isn't ;-).

Or just try adding a __packed to the xfs_dir2_sf_entry definition?
