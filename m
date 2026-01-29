Return-Path: <linux-xfs+bounces-30538-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKC2Gdmde2nOGAIAu9opvQ
	(envelope-from <linux-xfs+bounces-30538-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 18:50:17 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE923B337B
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 18:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49E423053ABA
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 17:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC923355804;
	Thu, 29 Jan 2026 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwENo6yT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89B735503D;
	Thu, 29 Jan 2026 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708772; cv=none; b=RTZiwURQJxyIFYulNhCAn0HdpHq/7K0XGqycs9RGg+gas/2t2GfinPTBVQWzujLdoFQoz607FgQ7HMm7dU3qWI7nr+xTeI9GDZUzLHrystNYgiNtXSKu3rTj5on5u6MYu8ceRN+V8xdki2ZugWrvLeCUGjIyizB0Qp0kNDqVuIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708772; c=relaxed/simple;
	bh=DYYrQBJ6UjuWz2802Ozqo2cKwlvUysnujXA1Vy/5oco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETRqk+h5vi16XtQM9s7eGq9SYbpO99mWrx4AnszdSlSMtKhGmDtlQjYRSLWwuxIpgWH986ymtqHMsSVANMdtqyWh8GodBl8ssKkO4nHaGjYmtZ5BDAHATS/O2J1kXcO+wksAdvsHI7cNW0ZcA/1D8DutUZDa5AlqRoDVZbY0SjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwENo6yT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BACC4CEF7;
	Thu, 29 Jan 2026 17:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769708772;
	bh=DYYrQBJ6UjuWz2802Ozqo2cKwlvUysnujXA1Vy/5oco=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=XwENo6yTqu0LZZtmtkrvLHpCc/1ykWMQjQNNY9Kn9xJOt+cwHWEA/zna2zpg/r7mo
	 rG2JYClPGPW/ghxyo2yf8/9crERy8eWhSSIiNm6vueVl12Qn7DQeRS6jpxkYgdCHQy
	 1H+1glyGCI0xjwwPTGu8YPHc4zue3/SzkbskzV1/SNXRY04SE+HUI84vA/OoyTozhR
	 Kxslvx58M8GWgh/9TaU7Nnn0jqOFqbOk0Fxr4HwswiPq41EXQXyp/vVDCTsaMZbBW+
	 3vIAVRIV1zmdm5j6/0PmHXchhgRxtIY1JalLRSG2Ae6MHGbJjww+iaunV43yZVpUci
	 g1lOLUrmrGp2w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 1D202CE0D17; Thu, 29 Jan 2026 09:46:12 -0800 (PST)
Date: Thu, 29 Jan 2026 09:46:12 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Kunwu Chan <kunwu.chan@hotmail.com>,
	"rcu@vger.kernel.org" <rcu@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: rcu stalls during fstests runs for xfs
Message-ID: <13b25e07-d7b8-4b4e-a249-b6826b2eea39@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
 <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
 <aXrl46PxeHQSpYbX@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXrl46PxeHQSpYbX@shinmob>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[hotmail.com,vger.kernel.org,lst.de];
	TAGGED_FROM(0.00)[bounces-30538-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[paulmck@kernel.org,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_REPLYTO(0.00)[paulmck@kernel.org]
X-Rspamd-Queue-Id: BE923B337B
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 05:27:04AM +0000, Shinichiro Kawasaki wrote:
> On Jan 28, 2026 / 08:42, Paul E. McKenney wrote:
> > On Wed, Jan 28, 2026 at 05:55:01PM +0800, Kunwu Chan wrote:
> > > On 1/26/26 19:30, Shinichiro Kawasaki wrote:
> > > >  kernel: xfs/for-next, 51aba4ca399, v6.19-rc5+
> > > >      block device: dm-linear on HDD (non-zoned)
> > > >      xfs: zoned
> > > 
> > > I had a quick look at the attached logs. Across the different runs, the
> > > stall traces consistently show CPUs spending extended time in
> > > |mm_get_cid()|along the mm/sched context switch path.
> > > 
> > > This doesn’t seem to indicate an immediate RCU issue by itself, but it
> > > raises the question of whether context switch completion can be delayed
> > > for unusually long periods under these test configurations.
> > 
> > Thank you all!
> > 
> > Us RCU guys looked at this and it also looks to us that at least one
> > part of this issue is that mm_get_cid() is spinning.  This is being
> > investigated over here:
> > 
> > https://lore.kernel.org/all/877bt29cgv.ffs@tglx/
> > https://lore.kernel.org/all/bdfea828-4585-40e8-8835-247c6a8a76b0@linux.ibm.com/
> > https://lore.kernel.org/all/87y0lh96xo.ffs@tglx/
> 
> Knuwu, Paul and RCU experts, thank you very much. It's good to know that the
> similar issue is already under investigation. I hope that a fix gets available
> in timely manner.
> 
> > I have seen the static-key pattern called out by Dave Chinner when running
> > KASAN on large systems.  We worked around this by disabling KASAN's use
> > of static keys.  In case you were running KASAN in these tests.
> 
> As to KASAN, yes, I enable it in my test runs. I find three static-keys under
> mm/kasan/*. I will think if they can be disabled in my test runs. Thanks.

There is a set of Kconfig options that disables static branches.  If you
cannot find them quickly, please let me know and I can look them up.

							Thanx, Paul

