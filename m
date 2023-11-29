Return-Path: <linux-xfs+bounces-234-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C507FCE63
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 06:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 770AA1C210B1
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 05:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075A46FD6;
	Wed, 29 Nov 2023 05:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0537619BD;
	Tue, 28 Nov 2023 21:42:27 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 502BD227A87; Wed, 29 Nov 2023 06:42:25 +0100 (CET)
Date: Wed, 29 Nov 2023 06:42:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Ritesh Harjani <ritesh.list@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/13] iomap: move the iomap_sector sector calculation
 out of iomap_add_to_ioend
Message-ID: <20231129054225.GE1385@lst.de>
References: <20231126124720.1249310-9-hch@lst.de> <87plzvr05y.fsf@doe.com> <20231127135402.GA23928@lst.de> <20231129045357.GN4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129045357.GN4167244@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 28, 2023 at 08:53:57PM -0800, Darrick J. Wong wrote:
> Can you change @offset to @pos while you're changing the function
> signature?

Sure.

