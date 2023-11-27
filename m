Return-Path: <linux-xfs+bounces-131-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4372D7FA15F
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Nov 2023 14:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8E64B2103C
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Nov 2023 13:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC433032A;
	Mon, 27 Nov 2023 13:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D54136;
	Mon, 27 Nov 2023 05:51:21 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id A04A367373; Mon, 27 Nov 2023 14:51:17 +0100 (CET)
Date: Mon, 27 Nov 2023 14:51:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/13] iomap: don't chain bios
Message-ID: <20231127135117.GB23428@lst.de>
References: <20231126124720.1249310-1-hch@lst.de> <20231126124720.1249310-10-hch@lst.de> <0f136350-3242-3e20-3b8a-56a39c66b001@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f136350-3242-3e20-3b8a-56a39c66b001@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 08:53:22PM +0800, Zhang Yi wrote:
> A nice cleanup! I'm just a little curious about the writeback performance
> impact of this patch. Do you have any actual test data on xfs?

I've only tested the entire series, not this patch specifically.  The
throughput doesn't change at all in my testing, and cpu usage goes
down a tiny amount, although it's probably below the measurement
tolerance.


